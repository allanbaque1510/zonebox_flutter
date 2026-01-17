import 'package:app_zonebox/services/color_service.dart';
import 'package:app_zonebox/services/icon_service.dart';
import 'package:flutter/material.dart';

class SelectorEstado extends StatelessWidget {
  final int? estadoActual;
  final List<dynamic> estados;
  final Function(int) onEstadoSeleccionado;

  const SelectorEstado({
    super.key,
    required this.estadoActual,
    required this.estados,
    required this.onEstadoSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.swap_horiz, color: Color(0xFF2563EB), size: 24),
              SizedBox(width: 12),
              Text(
                'Selecciona el nuevo estado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...estados.map((estado) {
            final isSelected = estadoActual == estado['id'];
            final color = ColorService().hexToColor(estado['color']);

            return GestureDetector(
              onTap: () => onEstadoSeleccionado(estado['id']),
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      isSelected ? color.withOpacity(0.1) : Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : Color(0xFFE5E7EB),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        IconService().getIconForEstado(estado['codigo']),
                        color: color,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        estado['nombre'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? color : Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 16),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
