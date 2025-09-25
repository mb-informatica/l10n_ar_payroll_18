#!/bin/bash

# =============================================================================
# SCRIPT PARA ACTUALIZAR M√ìDULO - GIT BASH EN VS CODE
# =============================================================================

echo "Ì¥ß Actualizando m√≥dulo l10n_ar_payroll..."

# Funci√≥n para mostrar el estado actual
show_status() {
    echo ""
    echo "Ì≥ä Estado actual del m√≥dulo:"
    echo "   Rama actual: $(git branch --show-current)"
    echo "   √öltimo commit: $(git log -1 --oneline)"
    echo ""
}

# Funci√≥n para hacer commit y push
commit_and_push() {
    local message="$1"
    echo "Ì≥¶ Agregando cambios..."
    git add .
    
    echo "Ì≤æ Haciendo commit..."
    git commit -m "$message"
    
    echo "Ì∫Ä Subiendo cambios..."
    git push origin $(git branch --show-current)
    
    echo "‚úÖ M√≥dulo actualizado y subido!"
}

# Funci√≥n para quitar dependencias problem√°ticas
fix_dependencies() {
    echo "Ì¥ß Quitando dependencias no disponibles en Odoo 18..."
    
    # Crear respaldo
    cp "l10n_ar_payroll/__manifest__.py" "l10n_ar_payroll/__manifest__.py.backup"
    
    # Quitar dependencias problem√°ticas
    sed -i "/hr_holidays_public/d" "l10n_ar_payroll/__manifest__.py"
    sed -i "/hr_attendance_report_theoretical_time/d" "l10n_ar_payroll/__manifest__.py" 
    sed -i "/hr_contract_rate/d" "l10n_ar_payroll/__manifest__.py"
    
    echo "‚úÖ Dependencias problem√°ticas removidas"
    commit_and_push "fix: remove unavailable dependencies for Odoo 18 installation"
}

# Funci√≥n para actualizar vista de contrato
fix_contract_view() {
    echo "Ì¥ß Verificando vista de contrato..."
    
    # Verificar si existe el archivo
    if [ ! -f "l10n_ar_payroll/views/hr_contract.xml" ]; then
        echo "‚ùå No se encuentra views/hr_contract.xml"
        echo "Ì¥ß Creando archivo de vista de contrato..."
        
        cat > "l10n_ar_payroll/views/hr_contract.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <record id="l10n_ar_payroll_hr_contract_view_form" model="ir.ui.view">
        <field name="name">hr.contract.view.form.inherit.l10n_ar_payroll</field>
        <field name="model">hr.contract</field>
        <field name="inherit_id" ref="hr_contract.hr_contract_view_form" />
        <field name="arch" type="xml">
            <xpath expr="//group[@name='yearly_advantages']" position="replace" />
            <xpath expr="//group[@name='main_info']" position="inside">
                <separator string="Campos AFIP"/>
                <group string="AFIP - Parametros">
                    <field name="cobertura_svco" widget="boolean_toggle"/>
                    <field name="afip_situacion_revista_id"/>
                    <field name="afip_codigo_siniestrado_id"/>
                    <field name="afip_condicion_id"/>
                    <field name="afip_modalidad_contratacion_id"/>
                    <field name="afip_actividad_id"/>
                    <field name="afip_localidad_id"/>
                    <field name="afip_obra_social_id"/>
                </group>
                <group string="AFIP - Adicionales">
                    <field name="ss_aporte_adicional"/>
                    <field name="ss_contrib_detraccion"/>
                    <field name="os_adherentes"/>
                    <field name="os_aporte_adicional"/>
                    <field name="os_contribucion_adicional"/>
                </group>
                <separator string="Parametros Adicionales" />
                <field name="hr_contract_advantage_ids">
                    <list editable="bottom">
                        <field name="contract_advantage_template_id"/>
                        <field name="advantage_lower_bound"/>
                        <field name="advantage_upper_bound"/>
                        <field name="use_default" widget="boolean_toggle"/>
                        <field name="override_amount" invisible="use_default == True"/>
                    </list>
                </field>
            </xpath>
        </field>
    </record>
</odoo>
EOF
        echo "‚úÖ Vista de contrato creada"
    else
        echo "‚úÖ Vista de contrato existe"
    fi
    
    commit_and_push "fix: ensure contract view is properly configured"
}

# Funci√≥n para actualizar versi√≥n
update_version() {
    local new_version="$1"
    echo "Ì¥ß Actualizando versi√≥n a $new_version..."
    
    sed -i "s/'version': '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*',/'version': '$new_version',/" "l10n_ar_payroll/__manifest__.py"
    
    echo "‚úÖ Versi√≥n actualizada"
    commit_and_push "bump: version to $new_version"
}

# Funci√≥n para forzar reinstalaci√≥n
reinstall_module() {
    echo "Ì¥Ñ Para reinstalar el m√≥dulo en Odoo, ejecuta:"
    echo ""
    echo "   ./odoo-bin -d tu_base_de_datos -u l10n_ar_payroll --log-level=info"
    echo ""
    echo "O desde la interfaz:"
    echo "   Apps ‚Üí l10n_ar_payroll ‚Üí Upgrade"
    echo ""
}

# MEN√ö PRINCIPAL
show_status

echo "¬øQu√© quieres hacer?"
echo ""
echo "1) Ì¥ß Quitar dependencias problem√°ticas"  
echo "2) Ìæ® Arreglar vista de contrato"
echo "3) Ì≥ù Actualizar versi√≥n"
echo "4) Ì≥¶ Solo hacer commit de cambios actuales"
echo "5) Ì¥Ñ Mostrar comandos de reinstalaci√≥n"
echo "6) Ì≥ä Ver estado actual"
echo ""

read -p "Elige una opci√≥n (1-6): " option

case $option in
    1)
        fix_dependencies
        reinstall_module
        ;;
    2)
        fix_contract_view
        reinstall_module
        ;;
    3)
        read -p "Nueva versi√≥n (ej: 18.0.3.1.0): " version
        update_version "$version"
        reinstall_module
        ;;
    4)
        read -p "Mensaje del commit: " message
        commit_and_push "$message"
        reinstall_module
        ;;
    5)
        reinstall_module
        ;;
    6)
        show_status
        ;;
    *)
        echo "‚ùå Opci√≥n no v√°lida"
        ;;
esac

echo ""
echo "Ìæâ ¬°Operaci√≥n completada!"
