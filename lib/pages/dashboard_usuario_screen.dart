import 'package:app_zonebox/models/user_model.dart';
import 'package:app_zonebox/pages/detalle_pedido_screen.dart';
import 'package:app_zonebox/pages/gestionar_pedido_screen.dart';
import 'package:app_zonebox/pages/historial_pedidos_screen.dart';
import 'package:app_zonebox/pages/perfil_usuario_screen.dart';
import 'package:app_zonebox/services/auth_service.dart';
import 'package:app_zonebox/services/gestionar_pedido_service.dart';
import 'package:app_zonebox/services/secure_storage.dart';
import 'package:app_zonebox/widgets/UsuarioDashboard/header_usuario.dart';
import 'package:app_zonebox/widgets/UsuarioDashboard/estadisticas_rapidas.dart';
import 'package:app_zonebox/widgets/UsuarioDashboard/card_pedido_pendiente.dart';
import 'package:app_zonebox/widgets/UsuarioDashboard/card_mi_pedido.dart';
import 'package:app_zonebox/widgets/custom_confirmation_dialog.dart';
import 'package:app_zonebox/widgets/loading.dart';
import 'package:flutter/material.dart';

class DashboardUsuarioScreen extends StatefulWidget {
  final UserModel? usuarioIndex;

  const DashboardUsuarioScreen({super.key, required this.usuarioIndex});

  @override
  State<DashboardUsuarioScreen> createState() => _DashboardUsuarioScreenState();
}

class _DashboardUsuarioScreenState extends State<DashboardUsuarioScreen>
    with SingleTickerProviderStateMixin {
  UserModel? usuario;
  late TabController _tabController;

  List<dynamic> pedidosPendientes = [];
  List<dynamic> misPedidosEnProceso = [];
  int totalCompletados = 0;
  int totalEnGestion = 0;
  int totalPendientes = 0;

  String searchQuery = '';
  bool _isLoading = false;
  bool isLoadingPendientes = false;
  bool isLoadingMisPedidos = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUser();
    _loadPedidos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final data = await SecureStorageService.getUser();
    if (data == null) {
      usuario = null;
      setState(() {});
      return;
    }
    usuario = UserModel.fromJson(data);
    setState(() {});
  }

  Future<void> _loadPedidos() async {
    setState(() {
      isLoadingPendientes = true;
      isLoadingMisPedidos = true;
    });

    try {
      final response = await GestionarPedidoService().obtenerPedidos();
      setState(() {
        pedidosPendientes = response['pedidosPendientes'];
        misPedidosEnProceso = response['pedidosEnGestion'];

        totalCompletados = response['countPedidosCompletados'];
        totalEnGestion = response['countPedidosEnGestion'];
        totalPendientes = response['countPedidosPendientes'];
      });
    } catch (e) {
      print('Error cargando pedidos: $e');
    } finally {
      setState(() {
        isLoadingPendientes = false;
        isLoadingMisPedidos = false;
      });
    }
  }

  Future<void> _reloadUser() async {
    final data = await AuthService().getUser();
    await SecureStorageService.saveUser(data);
    usuario = UserModel.fromJson(data);
    setState(() {});
  }

  Future<void> _refreshData() async {
    await Future.wait([_reloadUser(), _loadPedidos()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          Column(
            children: [
              HeaderUsuario(
                nombreUsuario: usuario?.primerNombre ?? 'Administrador',
                onHistorialTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistorialPedidosScreen(),
                    ),
                  );
                },
                onPerfilTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(),
                    ),
                  );
                },
                onSearchChanged: (value) {
                  setState(() => searchQuery = value);
                },
                tabController: _tabController,
                estadisticas: EstadisticasRapidas(
                  disponibles: totalPendientes,
                  asignados: totalEnGestion,
                  completados: totalCompletados,
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildPendientesAsignacion(), _buildMisPedidos()],
                ),
              ),
            ],
          ),
          if (_isLoading) Loading(),
        ],
      ),
    );
  }

  Widget _buildPendientesAsignacion() {
    if (isLoadingPendientes) {
      return Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
    }

    if (pedidosPendientes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Color(0xFF9CA3AF)),
            SizedBox(height: 16),
            Text(
              'No hay pedidos disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Los nuevos pedidos aparecerán aquí',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: Color(0xFF2563EB),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: pedidosPendientes.length,
        itemBuilder: (context, index) {
          final pedido = pedidosPendientes[index];
          return CardPedidoPendiente(
            pedido: pedido,
            onAsignar: () => _asignarPedido(pedido),
            onVerDetalles: () => _showDetalleDialog(pedido),
          );
        },
      ),
    );
  }

  Widget _buildMisPedidos() {
    if (isLoadingMisPedidos) {
      return Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
    }

    if (misPedidosEnProceso.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: Color(0xFF9CA3AF)),
            SizedBox(height: 16),
            Text(
              'No tienes pedidos asignados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Asígnate pedidos desde la pestaña anterior',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: Color(0xFF2563EB),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: misPedidosEnProceso.length,
        itemBuilder: (context, index) {
          final pedido = misPedidosEnProceso[index];
          return CardMiPedido(
            pedido: pedido,
            onGestionar: () => _showGestionarDialog(pedido),
            onVerDetalles: () => _showDetalleDialog(pedido),
          );
        },
      ),
    );
  }

  Future<void> _asignarPedido(dynamic pedido) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (context) => CustomConfirmationDialog(
            title: '¿Asignar pedido?',
            subTitle:
                '¿Deseas asignarte el pedido ${pedido['codigo']}?\n\nSerás responsable de gestionarlo hasta su entrega.',
          ),
    );
    debugPrint('Confirmar asignación: $confirmar');
    if (confirmar == true) {
      try {
        setState(() {
          _isLoading = true;
        });
        final response = await GestionarPedidoService().asignarPedido({
          'pedido': pedido['id'],
        });
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Pedido ${pedido['codigo']} asignado')),
              ],
            ),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        _loadPedidos();
      } catch (e) {
        final error = e.toString().split(':').last.trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Color(0xFFEF4444)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDetalleDialog(dynamic pedido) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallePedidoScreen(idPedido: pedido['id']),
      ),
    );
  }

  void _showGestionarDialog(dynamic pedido) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GestionarPedidoScreen(idPedido: pedido['id']),
      ),
    ).then((resultado) {
      if (resultado == true) {
        _loadPedidos(); // Recargar la lista
      }
    });
  }
}
