import 'package:app_zonebox/pages/detalle_pedido_screen.dart';
import 'package:app_zonebox/services/color_service.dart';
import 'package:app_zonebox/services/icon_service.dart';
import 'package:app_zonebox/services/pedido_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MisEnviosScreen extends StatefulWidget {
  const MisEnviosScreen({super.key});

  @override
  State<MisEnviosScreen> createState() => _MisEnviosScreenState();
}

class _MisEnviosScreenState extends State<MisEnviosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroSeleccionado = 'Todos';
  List<dynamic> _estados = [];
  bool _isLoading = false;

  List<dynamic> envios = [];
  List<dynamic> enviosFiltrados = [];

  @override
  void initState() {
    super.initState();
    enviosFiltrados = envios;
    _loadEnvios();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadEnvios() async {
    try {
      setState(() => _isLoading = true);
      final response = await PedidoService().listaPedidos();
      setState(() {
        envios = response['pedidos'];
        _estados = response['estados'];
        _aplicarFiltros();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _aplicarFiltros() {
    setState(() {
      enviosFiltrados =
          envios.where((envio) {
            // Filtro por estado
            bool cumpleFiltro =
                _filtroSeleccionado == 'Todos' ||
                envio['estado'] == _filtroSeleccionado;

            // Filtro por búsqueda
            bool cumpleBusqueda =
                _searchController.text.isEmpty ||
                envio['codigo'].toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );

            return cumpleFiltro && cumpleBusqueda;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header
          Container(
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
                padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  children: [
                    // Título y botón atrás
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mis Envíos',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${enviosFiltrados.length} envíos',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Barra de búsqueda
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => _aplicarFiltros(),
                        decoration: InputDecoration(
                          hintText: 'Buscar por código...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF2563EB),
                          ),
                          suffixIcon:
                              _searchController.text.isNotEmpty
                                  ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Color(0xFF6B7280),
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      _aplicarFiltros();
                                    },
                                  )
                                  : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filtros
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    _estados
                        .map(
                          (estado) => [
                            _buildFiltroChip(estado),
                            SizedBox(width: 10),
                          ],
                        )
                        .expand((x) => x)
                        .toList(),
              ),
            ),
          ),

          // Lista de envíos
          Expanded(
            child:
                _isLoading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2563EB),
                      ),
                    )
                    : enviosFiltrados.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                      onRefresh: () async {
                        // await _loadEnvios();
                      },
                      color: Color(0xFF2563EB),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: enviosFiltrados.length,
                        itemBuilder: (context, index) {
                          return _buildEnvioCard(enviosFiltrados[index]);
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroChip(String filtro) {
    bool isSelected = _filtroSeleccionado == filtro;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filtroSeleccionado = filtro;
          _aplicarFiltros();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
                  )
                  : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          filtro,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildEnvioCard(Map<String, dynamic> envio) {
    Color estadoColor = ColorService().hexToColor(envio['color']);
    IconData estadoIcon = IconService().getIconForEstado(
      envio['codigo_estado'],
    );

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
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => DetallePedidoScreen(idPedido: envio['id']),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Código y estado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: estadoColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(estadoIcon, color: estadoColor, size: 20),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              envio['codigo'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              envio['fecha'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: estadoColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        envio['estado'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: estadoColor,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),
                Divider(height: 1, thickness: 1),
                SizedBox(height: 16),

                // Ruta
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: Color(0xFF2563EB)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        envio['origen'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Color(0xFF9CA3AF),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        envio['destino'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.location_on, size: 16, color: Color(0xFF10B981)),
                  ],
                ),

                SizedBox(height: 12),

                // Precio y botón
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      envio['precio'] == null
                          ? '-'
                          : '\$${(double.tryParse(envio['precio'].toString()) ?? 0).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.copy, size: 18),
                          color: Color(0xFF6B7280),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: envio['codigo']),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Código copiado'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Color(0xFF10B981),
                              ),
                            );
                          },
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF9CA3AF),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Color(0xFF9CA3AF)),
          SizedBox(height: 20),
          Text(
            'No se encontraron envíos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty
                ? 'Intenta con otro código'
                : 'Cambia el filtro seleccionado',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}
