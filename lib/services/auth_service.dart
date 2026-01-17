import 'package:app_zonebox/services/http_service.dart';
import 'package:app_zonebox/services/secure_storage.dart';

class AuthService {
  Future<Map<String, dynamic>> login(data) async {
    final respuesta = await Httpservice().postRequest("login", data);
    if (respuesta != null) {
      await SecureStorageService.saveToken(respuesta['token']);
    }
    return respuesta;
  }

  Future<Map<String, dynamic>> register(data) async {
    final respuesta = await Httpservice().postRequest("register", data);
    if (respuesta != null) {
      await SecureStorageService.saveToken(respuesta['token']);
    }
    return respuesta;
  }

  Future<Map<String, dynamic>> getUser() async {
    return await Httpservice().getRequest("user");
  }

  Future<Map<String, dynamic>> verificarToken() async {
    return await Httpservice().getRequest("verificarToken", null, false);
  }

  Future<Map<String, dynamic>> logOut() async {
    return await Httpservice().getRequest("logout");
  }
}
