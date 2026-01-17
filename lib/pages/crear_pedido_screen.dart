import 'package:app_zonebox/config/pedido_form_builder.dart';
import 'package:app_zonebox/services/pedido_service.dart';
import 'package:flutter/material.dart';
import 'package:app_zonebox/widgets/custom_text_form_field.dart';
import 'package:app_zonebox/widgets/custom_select_form_field.dart';
import 'package:app_zonebox/widgets/loading.dart';

class CrearPedidoScreen extends StatefulWidget {
  const CrearPedidoScreen({super.key});

  @override
  State<CrearPedidoScreen> createState() => _CrearPedidoScreenState();
}

class _CrearPedidoScreenState extends State<CrearPedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  final Map<String, TextEditingController> _controllers = {};

  // Valores de los selects
  String? _empresaEnvioSeleccionada;
  String? _tiendaSeleccionada;
  String? _ciudadDestinoSeleccionada;
  String _idOtraTienda = '';
  bool enableOtraTienda = false;

  List<Map<String, dynamic>> empresasEnvio = [];
  List<Map<String, dynamic>> tiendas = [];
  List<Map<String, dynamic>> ciudadesDestino = [];

  bool _catalogosLoaded = false;

  void obtenerCatalogos() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final response = await PedidoService().createPedido();

      if (!mounted) return;

      final dataOtro = (response['tiendas'] as List).firstWhere(
        (data) => data['codigo'] == 'OTROS',
        orElse: () => null,
      );
      if (dataOtro != null) {
        _idOtraTienda = dataOtro['id'].toString();
      }

      setState(() {
        ciudadesDestino =
            (response['ciudades'] as List).map((ciudad) {
              return {
                'label': ciudad['nombre'] ?? ciudad['label'] ?? '',
                'value':
                    ciudad['id']?.toString() ??
                    ciudad['value']?.toString() ??
                    '',
              };
            }).toList();

        tiendas =
            (response['tiendas'] as List).map((tienda) {
              return {
                'label': tienda['nombre'] ?? tienda['label'] ?? '',
                'value':
                    tienda['id']?.toString() ??
                    tienda['value']?.toString() ??
                    '',
              };
            }).toList();

        empresasEnvio =
            (response['empresas_envio'] as List).map((empresa) {
              return {
                'label': empresa['nombre'] ?? empresa['label'] ?? '',
                'value':
                    empresa['id']?.toString() ??
                    empresa['value']?.toString() ??
                    '',
              };
            }).toList();

        _catalogosLoaded = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().split(':').last.trim();
        _catalogosLoaded = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerCatalogos();
    // Inicializar controladores para los campos del formulario
    for (var field in pedidoFormControls) {
      if (field['isSelect'] != true) {
        _controllers[field['name']] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  // ============================================
  // VALIDACIONES
  // ============================================

  String? _validateForm(String? value, String label, {bool optional = false}) {
    if (optional && (value == null || value.isEmpty)) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese $label';
    }
    return null;
  }

  String? _validateNumber(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese $label';
    }
    if (double.tryParse(value) == null) {
      return 'Ingrese un número válido';
    }
    if (double.parse(value) <= 0) {
      return 'El valor debe ser mayor a 0';
    }
    return null;
  }

  // ============================================
  // SUBMIT FORM
  // ============================================
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final envioData = {
          'numero_tracking': _controllers['numero_tracking']!.text.trim(),
          'descripcion': _controllers['descripcion']!.text.trim(),
          'id_empresa_envio': _empresaEnvioSeleccionada,
          'id_tienda': _tiendaSeleccionada,
          'otra_tienda': _controllers['otra_tienda']?.text.trim(),
          'id_ciudad_destino': _ciudadDestinoSeleccionada,
          'instruccion': _controllers['instruccion']?.text.trim(),
        };

        final pedidoEnviado = await PedidoService().generarPedido(envioData);

        if (!mounted) return;

        final codigo = pedidoEnviado['codigo'] as String;

        // Mostrar diálogo de éxito
        _showSuccessDialog(codigo);
      } catch (e) {
        setState(() {
          final error = e.toString().split(':').last.trim();
          _errorMessage = 'Error al crear el envío: $error';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog(String codigo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.zero,
            content: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF10B981).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Color(0xFF10B981),
                      size: 48,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '¡Envío Creado!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Tu envío ha sido registrado exitosamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Código',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          codigo,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Aceptar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  // ============================================
  // BUILD UI
  // ============================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
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
                              'Crear Envío',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Completa los datos del paquete',
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
                ),

                // Contenido con formulario
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child:
                        !_catalogosLoaded
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF2563EB),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Cargando catálogos...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  if (_errorMessage.isNotEmpty) ...[
                                    SizedBox(height: 16),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),
                                      child: Text(
                                        _errorMessage,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFFEF4444),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: obtenerCatalogos,
                                      child: Text('Reintentar'),
                                    ),
                                  ],
                                ],
                              ),
                            )
                            : SingleChildScrollView(
                              padding: EdgeInsets.all(24),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Sección Envío
                                    _buildSection(
                                      'Información de Envío',
                                      'envio',
                                    ),

                                    // Sección Paquete
                                    _buildSection(
                                      'Información del Paquete',
                                      'paquete',
                                    ),

                                    // Sección Destino
                                    _buildSection(
                                      'Información de Destino',
                                      'destino',
                                    ),

                                    // Sección Adicional
                                    _buildSection(
                                      'Información Adicional',
                                      'adicional',
                                    ),

                                    SizedBox(height: 24),

                                    // Mensaje de error
                                    if (_errorMessage.isNotEmpty)
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        margin: EdgeInsets.only(bottom: 16),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFEE2E2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Color(0xFFEF4444),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: Color(0xFFEF4444),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                _errorMessage,
                                                style: TextStyle(
                                                  color: Color(0xFFEF4444),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    // Botón de enviar
                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: _submitForm,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF10B981),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.send, size: 20),
                                            SizedBox(width: 12),
                                            Text(
                                              'Agregar Compra',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),

          if (_isLoading) Loading(),
        ],
      ),
    );
  }

  // ============================================
  // HELPER: BUILD SECTION
  // ============================================
  Widget _buildSection(String title, String sectionName) {
    final fieldsInSection =
        pedidoFormControls
            .where((field) => field['section'] == sectionName)
            .toList();

    if (fieldsInSection.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16),
        ...fieldsInSection.map((field) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: _buildField(field),
          );
        }),
        SizedBox(height: 12),
      ],
    );
  }

  // ============================================
  // HELPER: BUILD FIELD
  // ============================================
  Widget _buildField(Map<String, dynamic> field) {
    if (field['isSelect'] == true) {
      return _buildSelectField(field);
    } else {
      return _buildTextField(field);
    }
  }

  Widget _buildSelectField(Map<String, dynamic> field) {
    List<Map<String, dynamic>> options = [];
    String? value;

    switch (field['name']) {
      case 'id_empresa_envio':
        options = empresasEnvio;
        value = _empresaEnvioSeleccionada;
        break;
      case 'id_tienda':
        options = tiendas;
        value = _tiendaSeleccionada;
        break;
      case 'id_ciudad_destino':
        options = ciudadesDestino;
        value = _ciudadDestinoSeleccionada;
        break;
    }

    return CustomSelectFormField(
      labelText: field['label'],
      icon: field['icon'],
      options: options,
      value: value,
      onChanged: (newValue) {
        setState(() {
          switch (field['name']) {
            case 'id_empresa_envio':
              _empresaEnvioSeleccionada = newValue;
              break;
            case 'id_tienda':
              setState(() {
                enableOtraTienda = _idOtraTienda == newValue;
                _controllers['otra_tienda']?.clear();
              });
              _tiendaSeleccionada = newValue;
              break;
            case 'id_ciudad_destino':
              _ciudadDestinoSeleccionada = newValue;
              break;
          }
        });
      },
      validator:
          (value) =>
              value == null ? "Por favor selecciona ${field['label']}" : null,
    );
  }

  Widget _buildTextField(Map<String, dynamic> field) {
    final validarEnabled = field['name'] == 'otra_tienda';
    print(field['name'] + ': ' + validarEnabled.toString());
    return CustomTextFormField(
      controller: _controllers[field['name']]!,
      labelText: field['label'],
      icon: field['icon'],
      validator:
          field['name'] == 'precio'
              ? (value) => _validateNumber(value, field['label'])
              : (value) => _validateForm(
                value,
                field['label'],
                optional: field['optional'] ?? false,
              ),
      keyboardType: field['keyboardType'],
      obscureText: field['obscureText'],
      enabled: validarEnabled ? enableOtraTienda : true,
    );
  }
}
