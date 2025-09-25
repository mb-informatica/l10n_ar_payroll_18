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

    def _get_contract_advantage_inputs(self, contract):
        """Get contract advantage inputs"""
        res = []
        for advantage in contract.hr_contract_advantage_ids:
            res.append({
                "name": advantage.contract_advantage_template_id.name,
                "code": advantage.contract_advantage_template_id.code,
                "amount": advantage.amount
            })
        return res

    @api.model
    def _get_inputs_data(self, contracts, date_from, date_to):
        """Updated method for Odoo 18 to get input lines data"""
        res = super()._get_inputs_data(contracts, date_from, date_to)

        for contract in contracts:
            # Add contract advantages
            res.extend(self._get_contract_advantage_inputs(contract))

        return res

    def _check_sac_period_valid(self, date):
        return date.month in [6, 12]

    def _get_overtime_data(self, contract, day_from, day_to):
        return self.env['hr.overtime'].search([
            ('employee_id', '=', contract.employee_id.id),
            ('state', '=', 'validate'),
            ('start_date', '>=', day_from), 
            ('start_date', '<=', day_to),
        ])
