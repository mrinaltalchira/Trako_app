import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tonner_app/globals.dart';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8080/api";


  Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> postRequest(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to post data');
    }
  }




  Future<void> login(BuildContext context,String phone, String password) async {
    final endpoint = 'login';
    final data = {'phone': phone, 'password': password};

    try {
      final response = await postRequest(endpoint, data);
      if (response.statusCode == 200) {
        // Show toast with the response
       showSnackBar(
         context, 'Login successful: ${response.body}',
        );
      } else {
        showSnackBar( context,
            'Login failed: ${response.body}'
        );
      }
    } catch (e) {
      showSnackBar( context,
          'Error: $e'
      );

    }
  }
}



