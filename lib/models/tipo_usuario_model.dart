class TipoUsuarioModel {
  final int id;
  final String codigo;
  final String nombre;

  TipoUsuarioModel({
    required this.id,
    required this.codigo,
    required this.nombre,
  });

  factory TipoUsuarioModel.fromJson(Map<String, dynamic> json) {
    return TipoUsuarioModel(
      id: json["id"],
      codigo: json["codigo"],
      nombre: json["nombre"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "codigo": codigo, "nombre": nombre};
  }
}
