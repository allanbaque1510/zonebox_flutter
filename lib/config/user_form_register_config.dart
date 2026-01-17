import 'package:app_zonebox/models/form_field_config.dart';
import 'package:flutter/material.dart';

final List<Map<String, String>> optionTipoUsuario = [
  {'label': 'Cliente', 'value': 'CLIENT'},
  {'label': 'Usuario', 'value': 'USER'},
];

final List<FormFieldConfig> userFormFields = [
  FormFieldConfig(
    name: 'tipoUsuario',
    label: 'Tipo de usuario',
    icon: Icons.badge_outlined,
    isSelect: true,
  ),
  FormFieldConfig(
    name: 'nombre',
    label: 'Nombre',
    icon: Icons.person_outline,
    keyboardType: TextInputType.name,
  ),
  FormFieldConfig(
    name: 'apellido',
    label: 'Apellido',
    icon: Icons.person_outline,
    keyboardType: TextInputType.name,
  ),
  FormFieldConfig(name: 'cedula', label: 'Cédula', icon: Icons.fingerprint),
  FormFieldConfig(
    name: 'telefono',
    label: 'Teléfono',
    icon: Icons.phone_outlined,
    keyboardType: TextInputType.phone,
  ),
  FormFieldConfig(
    name: 'email',
    label: 'Correo electrónico',
    icon: Icons.email_outlined,
    keyboardType: TextInputType.emailAddress,
  ),
  FormFieldConfig(
    name: 'password',
    label: 'Contraseña',
    icon: Icons.lock_outline,
    keyboardType: TextInputType.visiblePassword,
    obscureText: true,
  ),
  FormFieldConfig(
    name: 'confirmPassword',
    label: 'Confirmar contraseña',
    icon: Icons.lock_outline,
    keyboardType: TextInputType.visiblePassword,
    obscureText: true,
  ),
];
