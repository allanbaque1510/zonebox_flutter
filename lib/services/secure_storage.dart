import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();

  // Guardar token de manera segura
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Obtener token de manera segura
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Eliminar token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Guardar usuario
  static Future<void> saveUser(Map<String, dynamic> usuario) async {
    final jsonString = jsonEncode(usuario);
    await _storage.write(key: 'user', value: jsonString);
  }

  // Obtener usuario
  static Future<Map<String, dynamic>?> getUser() async {
    final jsonString = await _storage.read(key: 'user');

    if (jsonString == null) return null;

    return jsonDecode(jsonString);
  }

  // Eliminar usuario
  static Future<void> deleteUser() async {
    await _storage.delete(key: 'user');
  }
}
