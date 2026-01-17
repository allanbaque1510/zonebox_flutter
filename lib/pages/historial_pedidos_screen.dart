import 'package:app_zonebox/pages/detalle_pedido_screen.dart';
import 'package:app_zonebox/services/gestionar_pedido_service.dart';
import 'package:flutter/material.dart';

class HistorialPedidosScreen extends StatefulWidget {
  const HistorialPedidosScreen({super.key});

  @override
  State<HistorialPedidosScreen> createState() => _HistorialPedidosScreenState();
}

class _HistorialPedidosScreenState extends State<HistorialPedidosScreen> {
  List<dynamic> pedidosCompletados = [];
  bool isLoading = false;

  ScrollController _scrollController = ScrollController();
  DateTime? fechaInicio;
  DateTime? fechaFin;

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPedidos() async {
    setState(() => isLoading = true);

    try {
      final response = await GestionarPedidoService().historial();

      setState(() {
        isLoading = false;
        pedidosCompletados = response['data'] ?? [];
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Historial de Pedidos'),
        backgroundColor: Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          pedidosCompletados.isEmpty && !isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 80, color: Color(0xFF9CA3AF)),
                    SizedBox(height: 16),
                    Text(
                      'No hay pedidos en el historial',
                      style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: pedidosCompletados.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == pedidosCompletados.length) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    );
                  }

                  final pedido = pedidosCompletados[index];
                  return _buildHistorialCard(pedido);
                },
              ),
    );
  }

  Widget _buildHistorialCard(dynamic pedido) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => DetallePedidoScreen(idPedido: pedido['id']),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Color(0xFF10B981),
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
                        'Entregado el ${pedido['fechaEntrega'] ?? pedido['fecha_entrega'] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
