import 'package:app_zonebox/models/casillero_model.dart';
import 'package:app_zonebox/models/tipo_usuario_model.dart';

class UserModel {
  final int id;
  final String nombre;
  final String apellido;
  final String primerNombre;
  final String primerApellido;
  final int idTipoUsuario;
  final String cedula;
  final String telefono;
  final String email;
  final bool activo;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final TipoUsuarioModel tipoUsuario;
  final CasilleroModel? casillero;

  UserModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.primerNombre,
    required this.primerApellido,
    required this.idTipoUsuario,
    required this.cedula,
    required this.telefono,
    required this.email,
    required this.activo,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.tipoUsuario,
    required this.casillero,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      nombre: json["nombre"],
      apellido: json["apellido"],
      primerNombre: json["primer_nombre"],
      primerApellido: json["primer_apellido"],
      idTipoUsuario: json["id_tipo_usuario"],
      cedula: json["cedula"],
      telefono: json["telefono"],
      email: json["email"],
      activo: json["activo"] == true,
      emailVerifiedAt: json["email_verified_at"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      tipoUsuario: TipoUsuarioModel.fromJson(json["tipo_usuario"]),
      casillero:
          json["casillero"] == null
              ? null
              : CasilleroModel.fromJson(json["casillero"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "apellido": apellido,
      "primer_nombre": primerNombre,
      "primer_apellido": primerApellido,
      "id_tipo_usuario": idTipoUsuario,
      "cedula": cedula,
      "telefono": telefono,
      "email": email,
      "activo": activo,
      "email_verified_at": emailVerifiedAt,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "tipo_usuario": tipoUsuario.toJson(),
      "casillero": casillero?.toJson(),
    };
  }
}
