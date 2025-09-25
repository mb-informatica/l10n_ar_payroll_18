# ? CHECKLIST POST-MIGRACIÓN ODOO 18

## Cambios Aplicados Automáticamente:
- [x] Versión actualizada a 18.0.3.0.0
- [x] Agregadas dependencias externas (num2words)
- [x] Campos de contrato actualizados
- [x] Método get_inputs ? _get_inputs_data
- [x] Sintaxis XML <tree>  <list>

## Verificaciones Manuales Necesarias:
- [ ] Instalar módulo en Odoo 18
- [ ] Probar creación de contratos
- [ ] Probar generación de payslips
- [ ] Verificar reportes PDF
- [ ] Probar campos AFIP

## Posibles Problemas:
- Verificar disponibilidad del módulo 'payroll' en Odoo 18
- Algunos módulos OCA pueden no estar disponibles
- Campo contract.amount puede necesitar ser contract.wage

## Archivos que pueden necesitar ajustes adicionales:
- data/hr_salary_rule_*.xml
- report/l10n_ar_payslip_report_template.xml
