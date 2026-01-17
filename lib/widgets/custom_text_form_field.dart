import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool enabled;
  final TextInputType keyboardType;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.hintText = '',
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscured = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: TextFormField(
        enabled: widget.enabled,
        controller: widget.controller,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText.isNotEmpty ? widget.hintText : null,
          hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),

          prefixIcon: Icon(
            widget.icon,
            color: _isFocused ? Color(0xFF2563EB) : Color(0xFF6B7280),
            size: 22,
          ),

          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    icon: Icon(
                      _isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _isFocused ? Color(0xFF2563EB) : Color(0xFF9CA3AF),
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                  : null,

          labelStyle: TextStyle(
            color: _isFocused ? Color(0xFF2563EB) : Color(0xFF6B7280),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),

          // Relleno interno mejorado
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),

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

          errorStyle: TextStyle(
            color: Color(0xFFEF4444),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),

          filled: true,
          fillColor:
              !widget.enabled
                  ? const Color.fromARGB(255, 225, 225, 225)
                  : (_isFocused
                      ? Color(0xFF2563EB).withOpacity(0.03)
                      : Colors.grey[50]),
        ),
      ),
    );
  }
}
