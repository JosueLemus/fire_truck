import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class ApiServices {
  final baseUrl = "192.168.1.3:3001";

  Future<String> postLogin(String email, String password) async {
    try {
      final passCryp = sha256.convert(utf8.encode(password)).toString();
      final url = Uri.http(baseUrl, '/bombers/login');
      final response = await http.post(
        url,
        body: {'email': email, 'password': passCryp},
      );
      final json = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        String? bomberCarId = json["data"]["bomberCarId"];
        if (bomberCarId != null) {
          return bomberCarId;
        } else {
          throw Exception("Error en la autenticación");
        }
      } else {
        throw Exception("Error en la autenticación");
      }
    } catch (e) {
      throw Exception("Error en la solicitud: $e");
    }
  }

  Future<void> postTokenDevice(String hash, String token) async {
    try {
      final url = Uri.http(baseUrl, '/bombers/register-token');
      await http.post(
        url,
        body: {'bomberid': hash, 'token': token},
      );
    } catch (e) {
      throw Exception("Error al enviar el token: $e");
    }
  }

  Future<void> updatePosition(
      String bomberCarId, String lon, String lat) async {
    try {
      final url = Uri.http(baseUrl, '/bombercars/updateposition');
      await http.post(
        url,
        body: {'bomberCarId': bomberCarId, 'lon': lon, 'lat': lat},
      );
    } catch (e) {
      throw Exception("Error al actualizar la posicion: $e");
    }
  }
}
