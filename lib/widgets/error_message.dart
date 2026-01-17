import 'package:flutter/material.dart';

class ErrorMessage extends StatefulWidget {
  final String message;
  const ErrorMessage({super.key, required this.message});

  @override
  State<ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<ErrorMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFEF4444), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.message,
              style: TextStyle(color: Color(0xFFDC2626), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
