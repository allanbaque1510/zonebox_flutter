import 'package:flutter/material.dart';

class HistorialCambios extends StatelessWidget {
  final List<dynamic> historial;

  const HistorialCambios({super.key, required this.historial});

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
        children:
            historial.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> item = entry.value;
              bool isLast = index == historial.length - 1;

              return _buildHistorialItem(
                estado: item['estado_pedido'],
                descripcion: item['estado_descripcion'],
                fecha: item['fecha'],
                completado: item['completado'],
                isLast: isLast,
              );
            }).toList(),
      ),
    );
  }

  Widget _buildHistorialItem({
    required String estado,
    required String descripcion,
    required String? fecha,
    required bool completado,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: completado ? Color(0xFF2563EB) : Color(0xFFE5E7EB),
                shape: BoxShape.circle,
              ),
              child: Icon(
                completado ? Icons.check : Icons.circle,
                color: Colors.white,
                size: completado ? 18 : 10,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: completado ? Color(0xFF2563EB) : Color(0xFFE5E7EB),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estado,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: completado ? Color(0xFF1F2937) : Color(0xFF9CA3AF),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  descripcion,
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
                if (fecha != null) ...[
                  SizedBox(height: 4),
                  Text(
                    _formatDate(fecha),
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    try {
      if (dateStr == null) return '';
      DateTime date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr ?? ''; // ← Cambio aquí
    }
  }
}
