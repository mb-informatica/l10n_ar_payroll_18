# ? CHECKLIST POST-MIGRACI�N ODOO 18

## Cambios Aplicados Autom�ticamente:
- [x] Versi�n actualizada a 18.0.3.0.0
- [x] Agregadas dependencias externas (num2words)
- [x] Campos de contrato actualizados
- [x] M�todo get_inputs ? _get_inputs_data
- [x] Sintaxis XML <tree>  <list>

## Verificaciones Manuales Necesarias:
- [ ] Instalar m�dulo en Odoo 18
- [ ] Probar creaci�n de contratos
- [ ] Probar generaci�n de payslips
- [ ] Verificar reportes PDF
- [ ] Probar campos AFIP

## Posibles Problemas:
- Verificar disponibilidad del m�dulo 'payroll' en Odoo 18
- Algunos m�dulos OCA pueden no estar disponibles
- Campo contract.amount puede necesitar ser contract.wage

## Archivos que pueden necesitar ajustes adicionales:
- data/hr_salary_rule_*.xml
- report/l10n_ar_payslip_report_template.xml
