import 'package:flutter/material.dart';
import 'package:app_zonebox/widgets/UsuarioDashboard/estadisticas_rapidas.dart';

class HeaderUsuario extends StatelessWidget {
  final String nombreUsuario;
  final VoidCallback onHistorialTap;
  final VoidCallback onPerfilTap;
  final Function(String) onSearchChanged;
  final TabController tabController;
  final EstadisticasRapidas estadisticas;

  const HeaderUsuario({
    super.key,
    required this.nombreUsuario,
    required this.onHistorialTap,
    required this.onPerfilTap,
    required this.onSearchChanged,
    required this.tabController,
    required this.estadisticas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Panel de Gestión",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Bienvenido, $nombreUsuario",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildHeaderButton(
                    icon: Icons.history,
                    onTap: onHistorialTap,
                  ),
                  SizedBox(width: 10),
                  _buildHeaderButton(
                    icon: Icons.person_outline,
                    onTap: onPerfilTap,
                  ),
                ],
              ),
            ),

            // Estadísticas
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: estadisticas,
            ),

            // Barra de búsqueda
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: onSearchChanged,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Buscar por código o cliente...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            // Tabs
            Container(
              color: Colors.white.withOpacity(0.1),
              child: TabBar(
                controller: tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.6),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                tabs: [
                  Tab(text: 'Pendientes de Asignación'),
                  Tab(text: 'Mis Pedidos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
