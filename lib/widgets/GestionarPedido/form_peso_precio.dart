import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormPesoPrecio extends StatelessWidget {
  final TextEditingController pesoController;
  final TextEditingController precioController;

  const FormPesoPrecio({
    super.key,
    required this.pesoController,
    required this.precioController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Campo Peso
          _buildInputField(
            controller: pesoController,
            label: 'Peso del Paquete',
            icon: Icons.scale,
            suffix: 'kg',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            hint: 'Ej: 2.5',
          ),

          SizedBox(height: 20),

          // Campo Precio
          _buildInputField(
            controller: precioController,
            label: 'Precio del Envío',
            icon: Icons.attach_money,
            suffix: 'USD',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            hint: 'Ej: 25.00',
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String suffix,
    required TextInputType keyboardType,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Color(0xFF6B7280)),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
              suffixText: suffix,
              suffixStyle: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }
}
