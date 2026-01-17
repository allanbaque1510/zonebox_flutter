import 'package:flutter/material.dart';

class FormFieldConfig {
  final String name;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isSelect;

  const FormFieldConfig({
    required this.name,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isSelect = false,
  });
}
