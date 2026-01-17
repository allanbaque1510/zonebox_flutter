class CasilleroModel {
  final int id;
  final int idUsuario;
  final int idCiudad;
  final String codigo;
  final String direccion;
  final String estado;
  final String zip;
  final String telefono;
  final String direccionCompleta;
  final String nombrePais;
  final String nombreCiudad;

  CasilleroModel({
    required this.id,
    required this.idUsuario,
    required this.idCiudad,
    required this.codigo,
    required this.direccion,
    required this.estado,
    required this.zip,
    required this.telefono,
    required this.direccionCompleta,
    required this.nombrePais,
    required this.nombreCiudad,
  });

  factory CasilleroModel.fromJson(Map<String, dynamic> json) {
    return CasilleroModel(
      id: json["id"],
      idUsuario: json["id_usuario"],
      idCiudad: json["id_ciudad"],
      codigo: json["codigo"],
      direccion: json["direccion"],
      estado: json["estado"],
      zip: json["zip"],
      telefono: json["telefono"],
      direccionCompleta: json["direccion_completa"],
      nombrePais: json["nombre_pais"],
      nombreCiudad: json["nombre_ciudad"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "id_usuario": idUsuario,
      "id_ciudad": idCiudad,
      "codigo": codigo,
      "direccion": direccion,
      "estado": estado,
      "zip": zip,
      "telefono": telefono,
      "direccion_completa": direccionCompleta,
      "nombre_pais": nombrePais,
      "nombre_ciudad": nombreCiudad,
    };
  }
}
