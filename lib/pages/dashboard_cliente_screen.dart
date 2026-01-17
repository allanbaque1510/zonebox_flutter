import 'package:app_zonebox/models/user_model.dart';
import 'package:app_zonebox/pages/crear_pedido_screen.dart';
import 'package:app_zonebox/pages/mis_envios_screen.dart';
import 'package:app_zonebox/pages/perfil_usuario_screen.dart';
import 'package:app_zonebox/services/auth_service.dart';
import 'package:app_zonebox/services/pedido_service.dart';
import 'package:app_zonebox/services/secure_storage.dart';
import 'package:app_zonebox/widgets/ClientDashboard/card_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardClientScreen extends StatefulWidget {
  final UserModel? usuarioIndex;

  const DashboardClientScreen({super.key, required this.usuarioIndex});

  @override
  State<DashboardClientScreen> createState() => _DashboardClientScreenState();
}

class _DashboardClientScreenState extends State<DashboardClientScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  int contadorPendientes = 0;
  int contadorEntregados = 0;
  int contadorEnTransito = 0;

  UserModel? usuario;

  List<dynamic> enviosActivos = [];

  @override
  void initState() {
    super.initState();
    usuario = widget.usuarioIndex;
    _loadInfo();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadInfo() async {
    final response = await PedidoService().obtenerPedidos();
    setState(() {
      enviosActivos = response['pedidos'];
      contadorPendientes = response['contadorPendientes'];
      contadorEntregados = response['contadorEntregados'];
      contadorEnTransito = response['contadorEnTransito'];
    });
  }

  Future<void> _reloadUser() async {
    final data = await AuthService().getUser();
    await SecureStorageService.saveUser(data);
    usuario = UserModel.fromJson(data);
    setState(() {});
  }

  Future<void> _refreshData() async {
    await Future.wait([_reloadUser(), _loadInfo()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header fijo
          Container(
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
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Row(
                  children: [
                    // Nombre del usuario
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hola, ${usuario?.primerNombre ?? 'Usuario'}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Gestiona tus envíos fácilmente",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Botones de acción
                    Row(
                      children: [
                        // Botón Crear Envío
                        _buildHeaderButton(
                          icon: Icons.add_box_rounded,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CrearPedidoScreen(),
                              ),
                            );

                            if (result == true) {
                              _loadInfo();
                            }
                          },
                        ),
                        SizedBox(width: 10),

                        _buildHeaderButton(
                          icon: Icons.receipt_long,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MisEnviosScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10),

                        // Botón Perfil
                        _buildHeaderButton(
                          icon: Icons.person_outline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Contenido con scroll
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: Color(0xFF2563EB),
              backgroundColor: Colors.white,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  // Estadísticas
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: Icons.pending_actions_rounded,
                          value: '$contadorPendientes',
                          label: 'Pendientes',
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          icon: Icons.local_shipping_rounded,
                          value: '$contadorEnTransito',
                          label: 'En Transito',
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          icon: Icons.check_circle_rounded,
                          value: '$contadorEntregados',
                          label: 'Entregados',
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  // CARRUSEL DE ENVÍOS ACTIVOS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Envíos Activos",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      if (enviosActivos.length > 1)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF2563EB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_currentPage + 1}/${enviosActivos.length}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Carrusel
                  enviosActivos.isEmpty
                      ? _buildNoShipmentsCard()
                      : SizedBox(
                        height: 280,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemCount: enviosActivos.length,
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double value = 1.0;
                                if (_pageController.position.haveDimensions) {
                                  value = _pageController.page! - index;
                                  value = (1 - (value.abs() * 0.1)).clamp(
                                    0.9,
                                    1.0,
                                  );
                                }
                                return Center(
                                  child: SizedBox(
                                    height:
                                        Curves.easeInOut.transform(value) * 280,
                                    child: child,
                                  ),
                                );
                              },
                              child: CardOrder(pedido: enviosActivos[index]),
                            );
                          },
                        ),
                      ),

                  // Indicadores
                  if (enviosActivos.length > 1) ...[
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        enviosActivos.length,
                        (index) => AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                _currentPage == index
                                    ? Color(0xFF2563EB)
                                    : Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 30),

                  // Casillero
                  _buildCasilleroCard(),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // WIDGETS
  // ============================================

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

  Widget _buildCasilleroCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF0EA5E9).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: Color(0xFF0EA5E9),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Mi Casillero',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CASILLERO',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      usuario?.casillero?.codigo ?? '',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: usuario?.casillero?.codigo ?? ''),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Casillero copiado'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.copy, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            title:
                'Dirección en ${usuario?.casillero?.nombreCiudad ?? 'Miami'}',
            content: usuario?.casillero?.direccionCompleta ?? '',
            context: context,
          ),
          Divider(height: 24, thickness: 1),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            title: 'Teléfono',
            content: usuario?.casillero?.telefono ?? '',
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildNoShipmentsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 60, color: Color(0xFF9CA3AF)),
          SizedBox(height: 16),
          Text(
            'No tienes envíos activos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Crea un nuevo envío para comenzar',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  static Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
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
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF0EA5E9).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFF0EA5E9), size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: content));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copiado al portapapeles'),
                duration: Duration(seconds: 2),
                backgroundColor: Color(0xFF10B981),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.copy, color: Color(0xFF6B7280), size: 18),
          ),
        ),
      ],
    );
  }
}
