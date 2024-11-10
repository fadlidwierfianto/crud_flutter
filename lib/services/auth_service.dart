import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resepmakanan_5b/models/response_model.dart';
import 'package:resepmakanan_5b/services/session_service.dart';

const String baseurl = 'https://recipe.incube.id/api';

class AuthService {
  final SessionService sessionService = SessionService();

  Future<Map<String, dynamic>> register(
    String name, String email, String password) async {
    final response = await http.post(Uri.parse('$baseurl/register'),
        body: {'name': name, 'email': email, 'password': password});

    if (response.statusCode == 201) {
      ResponseModel res = ResponseModel.formJson(jsonDecode(response.body));
      await sessionService.saveToken(res.data["token"]);
      await sessionService.saveUser(
        res.data["user"]["id"].toString(),
        res.data["user"]["name"],
        res.data["user"]["email"]);
      return {"status": true, "Message": res.message};
    } else if (response.statusCode == 422) {
      ResponseModel res = ResponseModel.formJson(jsonDecode(response.body));
      Map<String, dynamic> err = res.errors as Map<String, dynamic>;
      return {"status": false, "Message": res.message, "error": err};
    } else {
      throw Exception("failed to register");
    }
  }

    Future<Map<String, dynamic>> login(
    String email, String password) async {
    final response = await http.post(Uri.parse('$baseurl/login'),
        body: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      ResponseModel res = ResponseModel.formJson(jsonDecode(response.body));
      await sessionService.saveToken(res.data["token"]);
      await sessionService.saveUser(
        res.data["user"]["id"].toString(),
        res.data["user"]["name"],
        res.data["user"]["email"]);
      return {"status": true, "Message": res.message};
    } else if (response.statusCode == 401) {
      ResponseModel res = ResponseModel.formJson(jsonDecode(response.body));
      return {"status": false, "Message": res.message};
    } else {
      throw Exception("failed to login");
    }
  }
}
