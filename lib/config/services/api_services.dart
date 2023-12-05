import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class ApiServices {
  final baseUrl = "192.168.1.3:3001";

  // Future<List<FireTypes>> getFireTypes(String lastTimeModified) async {
  //   try {
  //     final queryParameters = {'lastTimeModified': lastTimeModified};
  //     final url = Uri.http(baseUrl, '/tipo-emergencias', queryParameters);
  //     final response = await http.get(url);

  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       final json = jsonDecode(response.body);
  //       print(json);
  //       return FireTypes.fromJsonList(json);
  //     } else {
  //       print("ERROR");
  //       throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error en la solicitud HTTP: $e');
  //     throw Exception('Error en la solicitud HTTP');
  //   }
  // }

  // Future<List<ComplaintLocal>> getHistoryList() async {
  //   try {
  //     final queryParameters = {'usuario': "el ya tu sabe"};
  //     final url = Uri.http(baseUrl, '/emergencias', queryParameters);
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final json = jsonDecode(response.body);
  //       return ComplaintLocal.fromJsonList(json);
  //     } else {
  //       print("ERROR");
  //       throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error en la solicitud HTTP: $e');
  //     throw Exception('Error en la solicitud HTTP');
  //   }
  // }

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

  // Future<bool> fileParts(ReportRequest request) async {
  //   try {
  //     final part = int.parse(request.part);

  //     final data = obtenerParte(request.audio, 5, part);
  //     if (data.isEmpty) {
  //       throw Exception("La parte de audio está vacía");
  //     }

  //     final bodyData = {
  //       'part': part.toString(),
  //       'requestId': request.hash,
  //       'filename': "audio",
  //       'extension': "mp3",
  //       'data': data,
  //     };
  //     print(bodyData);

  //     final url = Uri.http(baseUrl, '/emergencias/filepart');
  //     final response = await http.post(url, body: bodyData);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Manejar la respuesta exitosa si es necesario
  //       print("Parte del archivo enviada exitosamente");
  //       return true;
  //     } else {
  //       throw Exception("Error en la solicitud: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     // Manejar otros errores
  //     print("Error en la función fileParts: $e");
  //     throw Exception(e.toString());
  //   }
  // }
}
