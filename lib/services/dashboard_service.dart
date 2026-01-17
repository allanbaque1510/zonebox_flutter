import 'package:app_zonebox/services/http_service.dart';

class DashboardService {
  Future<Map<String, dynamic>> obtenerInformacion(String $idUsuario) async {
    return await Httpservice().getRequest(
      'dashboard/' + $idUsuario + '/obtenerInformacion',
    );
  }
}
