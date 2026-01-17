import 'package:app_zonebox/services/http_service.dart';

class GestionarPedidoService {
  Future<Map<String, dynamic>> obtenerPedidos() async {
    return await Httpservice().getRequest("gestionarPedido");
  }

  Future<Map<String, dynamic>> asignarPedido(data) async {
    return await Httpservice().postRequest("gestionarPedido/asignar", data);
  }

  Future<Map<String, dynamic>> historial() async {
    return await Httpservice().getRequest("gestionarPedido/historial");
  }

  Future<Map<String, dynamic>> pedido(idPedido) async {
    return await Httpservice().getRequest("gestionarPedido/$idPedido");
  }

  Future<Map<String, dynamic>> generarPedido(data) async {
    return await Httpservice().postRequest("gestionarPedido", data);
  }

  Future<Map<String, dynamic>> eliminarPedido(idPedido) async {
    return await Httpservice().deleteRequest("gestionarPedido/$idPedido");
  }

  Future<Map<String, dynamic>> modificarPedido(idPedido, data) async {
    return await Httpservice().putRequest("gestionarPedido/$idPedido", data);
  }
}
