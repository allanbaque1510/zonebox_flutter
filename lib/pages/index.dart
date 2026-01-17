import 'package:app_zonebox/models/user_model.dart';
import 'package:app_zonebox/pages/dashboard_cliente_screen.dart';
import 'package:app_zonebox/pages/dashboard_usuario_screen.dart';
import 'package:app_zonebox/services/auth_service.dart';
import 'package:app_zonebox/services/secure_storage.dart';
import 'package:app_zonebox/widgets/loading.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  UserModel? usuario;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final data = await AuthService().getUser();
      await SecureStorageService.saveUser(data);
      setState(() {
        usuario = UserModel.fromJson(data);
      });
    } catch (e) {
      print('Error al cargar el usuario: $e');
      setState(() {
        usuario = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Stack(children: [Loading()]));
    }
    print('Tipo de usuario: ${usuario}');
    if (usuario?.tipoUsuario.codigo == 'CLIENT') {
      return DashboardClientScreen(usuarioIndex: usuario);
    }

    if (usuario?.tipoUsuario.codigo == 'USER') {
      return DashboardUsuarioScreen(usuarioIndex: usuario);
    }

    return const Scaffold(
      body: Center(
        child: Text('Error: Tipo de usuario no reconocido o sesión inválida'),
      ),
    );
  }
}
