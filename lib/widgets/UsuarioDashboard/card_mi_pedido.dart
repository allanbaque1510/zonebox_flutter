import 'package:app_zonebox/services/color_service.dart';
import 'package:app_zonebox/services/icon_service.dart';
import 'package:flutter/material.dart';

class CardMiPedido extends StatelessWidget {
  final dynamic pedido;
  final VoidCallback onGestionar;
  final VoidCallback onVerDetalles;

  const CardMiPedido({
    super.key,
    required this.pedido,
    required this.onGestionar,
    required this.onVerDetalles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorService()
              .hexToColor(pedido['color_estado'])
              .withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorService()
                        .hexToColor(pedido['color_estado'])
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    IconService().getIconForEstado(pedido['codigo_estado']),
                    color: ColorService().hexToColor(pedido['color_estado']),
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pedido['codigo'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        pedido['cliente'] ?? 'Cliente',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorService()
                        .hexToColor(pedido['color_estado'])
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pedido['estado'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ColorService().hexToColor(pedido['color_estado']),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Divider(height: 1, thickness: 1),
            SizedBox(height: 16),

            // Detalles
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    icon: Icons.calendar_today,
                    label: 'Fecha',
                    value: pedido['fecha'] ?? 'N/A',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDetailItem(
                    icon: Icons.scale,
                    label: 'Peso',
                    value: '${pedido['peso'] ?? '0'} kg',
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    icon: Icons.location_on,
                    label: 'Origen',
                    value: pedido['origen'] ?? 'N/A',
                  ),
                ),
                Icon(Icons.arrow_forward, color: Color(0xFF9CA3AF), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: _buildDetailItem(
                    icon: Icons.place,
                    label: 'Destino',
                    value: pedido['destino'] ?? 'N/A',
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Botones
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onVerDetalles,
                    icon: Icon(Icons.info_outline, size: 18),
                    label: Text('Ver Detalles'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF2563EB),
                      side: BorderSide(color: Color(0xFF2563EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onGestionar,
                    icon: Icon(Icons.edit, size: 18),
                    label: Text('Gestionar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorService().hexToColor(
                        pedido['color_estado'],
                      ),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Color(0xFF6B7280)),
        SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
