import 'package:app_zonebox/pages/registrar_usario_screen.dart';
import 'package:app_zonebox/services/secure_storage.dart';
import 'package:app_zonebox/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:app_zonebox/pages/index.dart';
import 'package:app_zonebox/services/auth_service.dart';
import 'package:app_zonebox/widgets/custom_text_form_field.dart';
import 'package:app_zonebox/widgets/error_message.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';
  final Map<String, TextEditingController> _controllers = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _validateForm(value, name) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su $name';
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try {
        final response = await AuthService().login({
          'email': _controllers['email']!.text,
          'password': _controllers['password']!.text,
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

  void _navigateToRegister() {
    _formKey.currentState!.reset();
    _controllers.forEach((key, controller) => controller.clear());
    setState(() {
      _errorMessage = '';
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Register()),
    );
  }

  final List<Map<String, dynamic>> formFields = [
    {
      'name': 'email',
      'label': 'Correo electrónico',
      'icon': Icons.email_outlined,
      'keyboardType': TextInputType.emailAddress,
      'obscureText': false,
    },
    {
      'name': 'password',
      'label': 'Contraseña',
      'icon': Icons.lock_outline,
      'keyboardType': TextInputType.visiblePassword,
      'obscureText': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    for (var field in formFields) {
      _controllers[field['name']] = TextEditingController();
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
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
          // Fondo con gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0EA5E9), // Sky blue
                  Color(0xFF2563EB), // Blue
                  Color(0xFF1E40AF), // Dark blue
                ],
              ),
            ),
          ),

          // Elementos decorativos
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo/Imagen
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 30,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/zonedigital.jpg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(height: 40),

                        // Título
                        Text(
                          '¡Bienvenido!',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          'Inicia sesión para continuar',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 40),

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
                            padding: const EdgeInsets.all(28.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  if (_errorMessage.isNotEmpty) ...[
                                    ErrorMessage(message: _errorMessage),
                                    SizedBox(height: 20),
                                  ],

                                  ...formFields.map((field) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 20.0,
                                      ),
                                      child: CustomTextFormField(
                                        controller:
                                            _controllers[field['name']]!,
                                        labelText: field['label'],
                                        icon: field['icon'],
                                        validator:
                                            (value) => _validateForm(
                                              value,
                                              field['label'],
                                            ),
                                        keyboardType: field['keyboardType'],
                                        obscureText: field['obscureText'],
                                      ),
                                    );
                                  }),

                                  SizedBox(height: 10),

                                  // Botón de login
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF2563EB),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        elevation: 0,
                                        shadowColor: Color(
                                          0xFF2563EB,
                                        ).withOpacity(0.5),
                                      ),
                                      child: Text(
                                        "Iniciar Sesión",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 24),

                                  // Divisor
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey[300],
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          "O",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey[300],
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 24),

                                  // Link a registro
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "¿No tienes cuenta?",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: _navigateToRegister,
                                        style: TextButton.styleFrom(
                                          foregroundColor: Color(0xFF2563EB),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                        ),
                                        child: Text(
                                          "Regístrate",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
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
          ),

          if (_isLoading) Loading(),
        ],
      ),
    );
  }
}
