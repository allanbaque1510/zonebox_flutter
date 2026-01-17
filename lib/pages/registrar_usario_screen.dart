import 'package:app_zonebox/pages/index.dart';
import 'package:app_zonebox/services/auth_service.dart';
import 'package:app_zonebox/services/secure_storage.dart';
import 'package:app_zonebox/widgets/custom_select_form_field.dart';
import 'package:app_zonebox/widgets/custom_text_form_field.dart';
import 'package:app_zonebox/widgets/error_message.dart';
import 'package:app_zonebox/widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:app_zonebox/config/user_form_register_config.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';
  final Map<String, TextEditingController> _controllers = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? tipoUsuarioSeleccionado;

  String? _validateForm(value, name) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su $name';
    }
    return null;
  }

  Map<String, dynamic> buildRequestBody() {
    final Map<String, dynamic> data = {};

    for (var field in userFormFields) {
      final name = field.name;
      data[name] = _controllers[name]!.text.trim();
    }

    return data;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try {
        final response = await AuthService().register({
          ...buildRequestBody(),
          'tipoUsuario': tipoUsuarioSeleccionado,
        });

        if (!mounted) return;

        await SecureStorageService.saveUser(response['user']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Index()),
        );
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().split(':').last.trim();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    for (var field in userFormFields) {
      _controllers[field.name] = TextEditingController();
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
              ),
            ),
          ),

          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
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
                      Text(
                        'Crear Cuenta',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¡Únete a nosotros!',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Completa el formulario para comenzar',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),

                            SizedBox(height: 30),

                            // Card del formulario
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 30,
                                    offset: Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      if (_errorMessage.isNotEmpty) ...[
                                        ErrorMessage(message: _errorMessage),
                                        SizedBox(height: 20),
                                      ],

                                      // Campos del formulario
                                      ...userFormFields.map((field) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 18.0,
                                          ),
                                          child:
                                              field.isSelect == true
                                                  ? CustomSelectFormField(
                                                    labelText: field.label,
                                                    icon: field.icon,
                                                    options: optionTipoUsuario,
                                                    value:
                                                        tipoUsuarioSeleccionado,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        tipoUsuarioSeleccionado =
                                                            value;
                                                      });
                                                    },
                                                    validator:
                                                        (value) =>
                                                            value == null
                                                                ? "Por favor selecciona un ${field.label}"
                                                                : null,
                                                  )
                                                  : CustomTextFormField(
                                                    controller:
                                                        _controllers[field
                                                            .name]!,
                                                    labelText: field.label,
                                                    icon: field.icon,
                                                    validator:
                                                        (value) =>
                                                            _validateForm(
                                                              value,
                                                              field.label,
                                                            ),
                                                    keyboardType:
                                                        field.keyboardType,
                                                    obscureText:
                                                        field.obscureText,
                                                  ),
                                        );
                                      }),

                                      SizedBox(height: 10),

                                      // Botón de registro
                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: _submitForm,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF2563EB),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            "Crear Cuenta",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 20),

                                      // Términos y condiciones
                                      Text(
                                        'Al registrarte, aceptas nuestros Términos de Servicio y Política de Privacidad',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 30),
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
}
