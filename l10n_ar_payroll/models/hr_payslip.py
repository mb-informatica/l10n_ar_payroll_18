# Copyright (C) 2021 Nimarosa (Nicolas Rodriguez) (<nicolasrsande@gmail.com>).
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl).

from datetime import datetime, time, timedelta
from pytz import timezone
from num2words import num2words
from odoo import models, api, _
from odoo.exceptions import ValidationError


class HrPayslip(models.Model):
    _inherit = 'hr.payslip'

    @api.model
    def net_to_words_es(self, amount):
        return num2words(amount, to='currency', lang='es_CO')

    @api.model
    def ultimo_deposito_aportes(self):
        for record in self:
            slip_date = record.date_to
            last_month = slip_date.replace(day=1) - timedelta(days=1)
        return last_month

    @api.model
    def _get_inputs_data(self, contracts, date_from, date_to):
        """Updated method for Odoo 18"""
        res = super()._get_inputs_data(contracts, date_from, date_to)

        for contract in contracts:
            # Contract advantages
            for advantage in contract.hr_contract_advantage_ids:
                res.append({
                    "name": advantage.contract_advantage_template_id.name,
                    "code": advantage.contract_advantage_template_id.code,
                    "amount": advantage.amount
                })

            # SAC inputs
            if self._check_sac_period_valid(date_from):
                sac_base = {
                    "name": 'Mejor salario bruto mensual semestral - S.A.C',
                    "code": 'SACBASE', 
                    "amount": 0.00  # Simplified for initial migration
                }
                res.append(sac_base)

        return res

    def _check_sac_period_valid(self, date):
        return date.month in [6, 12]

    def _get_sac_semester(self, date):
        sac_semester = {'sac_year': date.year, 'sac_months': []}
        if date.month == 6:
            sac_semester['sac_months'] = [1, 2, 3, 4, 5]
        elif date.month == 12:
            sac_semester['sac_months'] = [7, 8, 9, 10, 11]
        return sac_semester
