import 'package:app_zonebox/services/http_service.dart';

class PedidoService {
  Future<Map<String, dynamic>> obtenerPedidos() async {
    return await Httpservice().getRequest("pedidos");
  }

  Future<Map<String, dynamic>> listaPedidos() async {
    return await Httpservice().getRequest("pedidos/lista");
  }

  Future<Map<String, dynamic>> createPedido() async {
    return await Httpservice().getRequest("pedidos/create");
  }

  Future<Map<String, dynamic>> pedido(idPedido) async {
    return await Httpservice().getRequest("pedidos/$idPedido");
  }

  Future<Map<String, dynamic>> generarPedido(data) async {
    return await Httpservice().postRequest("pedidos", data);
  }

  Future<Map<String, dynamic>> eliminarPedido(idPedido) async {
    return await Httpservice().deleteRequest("pedidos/$idPedido");
  }

  Future<Map<String, dynamic>> modificarPedido(idPedido, data) async {
    return await Httpservice().putRequest("pedidos/$idPedido", data);
  }
}
