import 'package:flutter/material.dart';

class CustomSelectFormField extends StatefulWidget {
  final String labelText;
  final IconData icon;
  final List<Map<String, dynamic>> options;
  final String? value;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final String? hintText;

  const CustomSelectFormField({
    Key? key,
    required this.labelText,
    required this.icon,
    required this.options,
    required this.value,
    required this.onChanged,
    this.validator,
    this.hintText,
  }) : super(key: key);

  @override
  State<CustomSelectFormField> createState() => _CustomSelectFormFieldState();
}

class _CustomSelectFormFieldState extends State<CustomSelectFormField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: DropdownButtonFormField<String>(
        value: widget.value,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w500,
        ),

        iconEnabledColor: _isFocused ? Color(0xFF2563EB) : Color(0xFF6B7280),
        iconDisabledColor: Color(0xFF9CA3AF),

        iconSize: 24,

        hint:
            widget.hintText != null
                ? Text(
                  widget.hintText!,
                  style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                )
                : null,

        decoration: InputDecoration(
          labelText: widget.labelText,

          prefixIcon: Icon(
            widget.icon,
            color: _isFocused ? Color(0xFF2563EB) : Color(0xFF6B7280),
            size: 22,
          ),

          labelStyle: TextStyle(
            color: _isFocused ? Color(0xFF2563EB) : Color(0xFF6B7280),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),

          // Relleno interno mejorado
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),

          // Bordes con colores modernos
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2563EB), width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),

          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFEF4444), width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFEF4444), width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),

          // Estilo del mensaje de error
          errorStyle: TextStyle(
            color: Color(0xFFEF4444),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),

          filled: true,
          fillColor:
              _isFocused
                  ? Color(0xFF2563EB).withOpacity(0.03)
                  : Colors.grey[50],
        ),

        items:
            widget.options
                .map(
                  (opt) => DropdownMenuItem<String>(
                    value: opt['value'].toString(),
                    child: Text(
                      opt['label'].toString(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),

        onChanged: widget.onChanged,

        dropdownColor: Colors.white,

        // Elevación del menú
        elevation: 8,

        borderRadius: BorderRadius.circular(12),

        menuMaxHeight: 300,
      ),
    );
  }
}
