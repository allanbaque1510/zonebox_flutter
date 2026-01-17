import 'dart:convert';
import 'dart:io';
import 'package:app_zonebox/config/config.dart';
import 'package:app_zonebox/services/navigation_service.dart';
import 'package:app_zonebox/services/secure_storage.dart';
import 'package:http/http.dart' as http;

class Httpservice {
  Future<dynamic> getRequest(
    String endpoint, [
    Map<String, dynamic>? params,
    redirectLogin = true,
  ]) async {
    final token = await SecureStorageService.getToken();

    final uri = Uri.parse("${Config.apiUrl}/$endpoint").replace(
      queryParameters: params?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final respuesta = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return respuesta["data"];
    } else if (response.statusCode == 401) {
      return _handleUnauthorized(redirectLogin: redirectLogin);
    } else {
      throw Exception(respuesta["message"]);
    }
  }

  Future<dynamic> postRequest(String endpoint, data) async {
    final token = await SecureStorageService.getToken();
    final response = await http.post(
      Uri.parse("${Config.apiUrl}/$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );
    final respuesta = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return respuesta["data"];
    } else if (response.statusCode == 401) {
      return _handleUnauthorized();
    } else {
      throw Exception(respuesta["message"]);
    }
  }

  Future<dynamic> postRequestWithFile(
    String endpoint,
    Map<String, String> fields,
    File file,
  ) async {
    final token = await SecureStorageService.getToken();
    var uri = Uri.parse("${Config.apiUrl}/$endpoint");
    var request = http.MultipartRequest('POST', uri);
    // Headers
    request.headers.addAll({'Authorization': 'Bearer $token'});
    // Campos normales (nombre, etc.)
    request.fields.addAll(fields);
    // Archivo
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    // Enviar
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data["data"];
    } else if (response.statusCode == 401) {
      return _handleUnauthorized();
    } else {
      throw Exception(data["message"]);
    }
  }

  Future<dynamic> putRequest(String endpoint, data) async {
    final token = await SecureStorageService.getToken();
    final response = await http.put(
      Uri.parse("${Config.apiUrl}/$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );

    final respuesta = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return respuesta["data"];
    } else if (response.statusCode == 401) {
      return _handleUnauthorized();
    } else {
      throw Exception(respuesta["message"]);
    }
  }

  Future<dynamic> putRequestWithFile(
    String endpoint,
    Map<String, String> fields,
    File file,
  ) async {
    final token = await SecureStorageService.getToken();
    var uri = Uri.parse("${Config.apiUrl}/$endpoint");
    var request = http.MultipartRequest('PUT', uri);

    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.fields.addAll(fields);

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data["data"];
    } else if (response.statusCode == 401) {
      return _handleUnauthorized();
    } else {
      throw Exception(data["message"]);
    }
  }

  Future<dynamic> deleteRequest(String endpoint) async {
    final token = await SecureStorageService.getToken();

    final response = await http.delete(
      Uri.parse("${Config.apiUrl}/$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final respuesta = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return respuesta["data"];
    } else if (response.statusCode == 401) {
      return _handleUnauthorized();
    } else {
      throw Exception(respuesta["message"]);
    }
  }

  Future<Never> _handleUnauthorized({bool redirectLogin = true}) async {
    await SecureStorageService.deleteToken();
    await SecureStorageService.deleteUser();

    if (redirectLogin) {
      NavigationService.redirectToLogin();
    }

    throw Exception("🔑 El token ha caducado");
  }
}
