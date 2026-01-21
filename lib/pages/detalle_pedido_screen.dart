import 'package:app_zonebox/services/color_service.dart';
import 'package:app_zonebox/services/icon_service.dart';
import 'package:app_zonebox/services/pedido_service.dart';
import 'package:app_zonebox/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetallePedidoScreen extends StatefulWidget {
  final int idPedido;

  const DetallePedidoScreen({super.key, required this.idPedido});

  @override
  State<DetallePedidoScreen> createState() => _DetallePedidoScreenState();
}

class _DetallePedidoScreenState extends State<DetallePedidoScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? pedido;

  @override
  void initState() {
    super.initState();
    _loadPedido();
  }

  void _loadPedido() async {
    try {
      setState(() => _isLoading = true);

      final response = await PedidoService().pedido(widget.idPedido);

      setState(() {
        pedido = response;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
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
                  // Header con gradiente
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorService().lighten(
                            ColorService().hexToColor(
                              pedido!['estado']['color'],
                            ),
                            0.5,
                          ),
                          ColorService().hexToColor(pedido!['estado']['color']),
                          ColorService().darken(
                            ColorService().hexToColor(
                              pedido!['estado']['color'],
                            ),
                            0.4,
                          ),
                        ],
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
                            // Botón atrás
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Detalle del Envío',
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
                                // Botón copiar código
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.copy,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(text: pedido!['codigo']),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Código copiado'),
                                          backgroundColor: Color(0xFF10B981),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Estado actual - Card destacado
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      IconService().getIconForEstado(
                                        pedido!['estado']['codigo'],
                                      ),
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Estado Actual',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          pedido!['estado']['nombre'],
                                          style: TextStyle(
                                            fontSize: 18,
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
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Contenido scrolleable
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Información General
                          _buildSectionTitle('Información General'),
                          SizedBox(height: 12),
                          _buildInfoCard([
                            _buildInfoRow(
                              'Número de Tracking',
                              pedido!['numero_tracking'],
                              Icons.tag,
                              canCopy: true,
                            ),
                            Divider(height: 24),
                            _buildInfoRow(
                              'Descripción',
                              pedido!['descripcion'],
                              Icons.description,
                            ),
                            Divider(height: 24),
                            _buildInfoRow(
                              'Precio',
                              pedido?['precio'] == null
                                  ? '-'
                                  : '\$${(double.tryParse(pedido!['precio'].toString()) ?? 0).toStringAsFixed(2)}',
                              Icons.attach_money,
                              highlight: true,
                            ),
                          ]),

                          SizedBox(height: 24),

                          // Detalles de Envío
                          _buildSectionTitle('Detalles de Envío'),
                          SizedBox(height: 12),
                          _buildInfoCard([
                            _buildInfoRow(
                              'Empresa de Envío',
                              pedido!['empresa_envio']['nombre'],
                              Icons.business,
                            ),
                            Divider(height: 24),
                            _buildInfoRow(
                              'Tienda',
                              pedido!['tienda']['nombre'],
                              Icons.store,
                            ),
                            if (pedido!['otra_tienda'] != null) ...[
                              Divider(height: 24),
                              _buildInfoRow(
                                'Otra Tienda',
                                pedido!['otra_tienda'],
                                Icons.store_outlined,
                              ),
                            ],
                            Divider(height: 24),
                            _buildInfoRow(
                              'Ciudad Destino',
                              pedido!['ciudad_destino']['nombre'],
                              Icons.location_city,
                            ),
                          ]),

                          SizedBox(height: 24),

                          // Fechas
                          _buildSectionTitle('Fechas'),
                          SizedBox(height: 12),
                          _buildInfoCard([
                            _buildInfoRow(
                              'Fecha de entrega',
                              _formatDate(pedido!['fecha_entrega']),
                              Icons.calendar_today,
                            ),
                            Divider(height: 24),
                            _buildInfoRow(
                              'Fecha de Entrega Estimada',
                              _formatDate(
                                pedido!['fecha_entrega_estimada'],
                                hour: false,
                              ),
                              Icons.event_available,
                            ),
                          ]),

                          if (pedido!['instruccion'] != null ||
                              pedido!['factura_comercial'] != null) ...[
                            SizedBox(height: 24),
                            _buildSectionTitle('Información Adicional'),
                            SizedBox(height: 12),
                            _buildInfoCard([
                              if (pedido!['instruccion'] != null)
                                _buildInfoRow(
                                  'Instrucciones',
                                  pedido!['instruccion'],
                                  Icons.note_alt,
                                ),
                              if (pedido!['instruccion'] != null &&
                                  pedido!['factura_comercial'] != null)
                                Divider(height: 24),
                              if (pedido!['factura_comercial'] != null)
                                _buildInfoRow(
                                  'Factura Comercial',
                                  pedido!['factura_comercial'],
                                  Icons.receipt_long,
                                ),
                            ]),
                          ],

                          SizedBox(height: 24),

                          // Historial de Estados
                          _buildSectionTitle('Historial de Seguimiento'),
                          SizedBox(height: 12),
                          _buildTimelineCard(),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
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

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    bool highlight = false,
    bool canCopy = false,
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
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: highlight ? 20 : 15,
                  fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
                  color: highlight ? Color(0xFF2563EB) : Color(0xFF1F2937),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (canCopy)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copiado al portapapeles'),
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

  Widget _buildTimelineCard() {
    List<dynamic> historial = pedido!['historial_estados'];

    return Container(
      width: double.infinity,
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

              return _buildTimelineItem(
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

  Widget _buildTimelineItem({
    required String estado,
    required String descripcion,
    required String? fecha,
    required bool completado,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indicador
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

        // Contenido
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
                    fecha,
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

  String _formatDate(String? dateStr, {bool hour = true}) {
    try {
      if (dateStr == null) return '';
      DateTime date = DateTime.parse(dateStr);
      if (hour) {
        return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      }
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }
}
