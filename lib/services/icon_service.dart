import 'package:flutter/material.dart';

class IconService {
  IconData getIconForEstado(String nombre) {
    switch (nombre) {
      case 'CREADO':
        return Icons.note_add;
      case 'EN_GESTION':
        return Icons.assignment_outlined;
      case 'RECIBIDO':
        return Icons.warehouse;
      case 'TRANSITO':
        return Icons.flight_takeoff;
      case 'DESTINO':
        return Icons.location_on;
      case 'ENTREGADO':
        return Icons.check_circle;
      default:
        return Icons.local_shipping;
    }
  }
}
