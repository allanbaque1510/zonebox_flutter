import 'package:app_zonebox/services/gestionar_pedido_service.dart';
import 'package:app_zonebox/widgets/GestionarPedido/selector_estado.dart';
import 'package:app_zonebox/widgets/GestionarPedido/form_peso_precio.dart';
import 'package:app_zonebox/widgets/GestionarPedido/historial_cambios.dart';
import 'package:app_zonebox/widgets/loading.dart';
import 'package:flutter/material.dart';

class GestionarPedidoScreen extends StatefulWidget {
  final int idPedido;

  const GestionarPedidoScreen({super.key, required this.idPedido});

  @override
  State<GestionarPedidoScreen> createState() => _GestionarPedidoScreenState();
}

class _GestionarPedidoScreenState extends State<GestionarPedidoScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  Map<String, dynamic>? pedido;

  // Controladores
  final _pesoController = TextEditingController();
  final _precioController = TextEditingController();

  // Estado seleccionado
  int? estadoSeleccionado;
  List<dynamic> estadosDisponibles = [];

  @override
  void initState() {
    super.initState();
    _loadPedido();
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _loadPedido() async {
    try {
      setState(() => _isLoading = true);

      final response = await GestionarPedidoService().pedido(widget.idPedido);

      setState(() {
        pedido = response;
        estadoSeleccionado = pedido!['estado']['id'];

        _pesoController.text = pedido!['peso']?.toString() ?? '';
        _precioController.text = pedido!['precio']?.toString() ?? '';

        estadosDisponibles = pedido!['estados_disponibles'] ?? [];

        _isLoading = false;
      });
    } catch (e) {
      _mostrarError('Error cargando pedido: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _guardarCambios() async {
    if (estadoSeleccionado == null) {
      _mostrarError('Debes seleccionar un estado');
      return;
    }

    if (_pesoController.text.isEmpty) {
      _mostrarError('El peso es obligatorio');
      return;
    }

    if (_precioController.text.isEmpty) {
      _mostrarError('El precio es obligatorio');
      return;
    }

    try {
      setState(() => _isSaving = true);

      final datos = {
        'estado_id': estadoSeleccionado,
        'peso': double.parse(_pesoController.text),
        'precio': double.parse(_precioController.text),
      };

      await GestionarPedidoService().modificarPedido(widget.idPedido, datos);

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Cambios guardados exitosamente'),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      final error = e.toString().split(':').last.trim();
      setState(() => _isSaving = false);
      _mostrarError(error);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Color(0xFFEF4444)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body:
          _isLoading
              ? Stack(children: [Loading()])
              : Column(
                children: [
                  // Header
                  _buildHeader(),

                  // Contenido
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Selector de Estado
                          _buildSectionTitle('Actualizar Estado'),
                          SizedBox(height: 12),
                          SelectorEstado(
                            estadoActual: estadoSeleccionado,
                            estados: estadosDisponibles,
                            onEstadoSeleccionado: (id) {
                              setState(() => estadoSeleccionado = id);
                            },
                          ),

                          SizedBox(height: 24),

                          // Formulario Peso y Precio
                          _buildSectionTitle('Información del Paquete'),
                          SizedBox(height: 12),
                          FormPesoPrecio(
                            pesoController: _pesoController,
                            precioController: _precioController,
                          ),

                          SizedBox(height: 24),

                          // Historial de cambios
                          if (pedido!['historial_estados'] != null &&
                              pedido!['historial_estados'].isNotEmpty) ...[
                            _buildSectionTitle('Historial de Cambios'),
                            SizedBox(height: 12),
                            HistorialCambios(
                              historial: pedido!['historial_estados'],
                            ),
                          ],

                          SizedBox(
                            height: 80,
                          ), // Espacio para el botón flotante
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      // Botón guardar flotante
      floatingActionButton:
          _isLoading
              ? null
              : FloatingActionButton.extended(
                onPressed: _isSaving ? null : _guardarCambios,
                backgroundColor: Color(0xFF2563EB),
                icon:
                    _isSaving
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Icon(Icons.save, color: Colors.white),
                label: Text(
                  _isSaving ? 'Guardando...' : 'Guardar Cambios',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gestionar Pedido',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          pedido!['codigo'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Info rápida del cliente
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cliente',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      pedido!['nombreCliente'] ?? 'N/A',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937),
      ),
    );
  }
}
