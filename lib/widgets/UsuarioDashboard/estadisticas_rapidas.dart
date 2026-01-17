import 'package:flutter/material.dart';

class EstadisticasRapidas extends StatelessWidget {
  final int disponibles;
  final int asignados;
  final int completados;

  const EstadisticasRapidas({
    super.key,
    required this.disponibles,
    required this.asignados,
    required this.completados,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickStat(
            icon: Icons.assignment_outlined,
            value: '$disponibles',
            label: 'Disponibles',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildQuickStat(
            icon: Icons.local_shipping,
            value: '$asignados',
            label: 'En gestion',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildQuickStat(
            icon: Icons.check_circle,
            value: '$completados',
            label: 'Completados',
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.9),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
