import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:resepmakanan_5b/models/recipe_model.dart';
import 'package:resepmakanan_5b/services/session_service.dart';

const String baseurl = 'https://recipe.incube.id/api';

class RecipeService {
  SessionService _sessionService = SessionService();

  Future<List<RecipeModel>> getAllRecipe() async {
    final token = await _sessionService.getToken();

    if (token == null || token.isEmpty) {
      print('Tidak ada token');
    }

    final response = await http.get(Uri.parse('$baseurl/recipes'), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    print(response.body);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data']['data'];
      return data.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<RecipeModel> getRecipeById(String id) async {
    final token = await _sessionService.getToken();

    if (token == null || token.isEmpty) {
      print('Tidak ada token');
    }
    final response =
        await http.get(Uri.parse('$baseurl/recipes/$id'), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return RecipeModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Recipe not found');
    } else {
      throw Exception('Failed to load recipe');
    }
  }

  Future<Map<String, dynamic>> submitData(String title, String cookingMethod,
      String ingredients, String description, File image) async {
    try {
      final token = await _sessionService.getToken();

      if (token == null || token.isEmpty) {
        if (kDebugMode) {
          print('Token kosong');
        }
        return {'status': false, 'message': 'Token tidak valid'};
      }

      var request =
          http.MultipartRequest('POST', Uri.parse('$baseurl/recipes'));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = title;
      request.fields['cooking_method'] = cookingMethod;
      request.fields['ingredients'] = ingredients;
      request.fields['description'] = description;
      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          await image.readAsBytes(),
          filename: image.path.split('/').last,
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        var responseJson = jsonDecode(response.body);
        return {
          'status': true,
          'message': responseJson['message'] ?? 'Berhasil mengirim data'
        };
      } else if (response.statusCode == 422) {
        return {'status': false, 'message': 'Validasi gagal. Cek input Anda'};
      } else {
        return {
          'status': false,
          'message': 'Terjadi kesalahan. Kode: ${response.statusCode}'
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return {'status': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
