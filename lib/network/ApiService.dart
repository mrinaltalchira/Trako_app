import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tonner_app/model/all_clients.dart';
import 'package:tonner_app/model/all_machine.dart';
import 'package:tonner_app/model/all_user.dart';
import 'package:tonner_app/pref_manager.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.29:8000/api';
  late Dio _dio;
  late String? token;

  ApiService() {
    initializeApiService();
  }

  Future<void> initializeApiService() async {
    try {
      token = await PrefManager().getToken();

      BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      );
      _dio = Dio(options);
      _dio.interceptors.add(LoggerInterceptor());
    } catch (e) {
      print('Failed to initialize ApiService: $e');
      throw Exception('Failed to initialize ApiService');
    }
  }

  Future<Map<String, dynamic>> login(String? email, String? phone, String password) async {
    try {
      await initializeApiService(); // Ensure token is initialized before login

      final response = await _dio.post(
        '$baseUrl/login',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode({
          if (email != null && email.isNotEmpty) 'email': email,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 15));

      return response.data;
    } catch (e) {
      print('Login API error: $e');
      throw Exception('Login API Failed to connect to the server.');
    }
  }


  ///////////////////////////////// client

  Future<Map<String, dynamic>> addClient({
    required String name,
    required String city,
    required String email,
    required String phone,
    required String address,
    required String contactPerson,
  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before addClient

      final url = '/add-client'; // Adjust endpoint as per your API
      final response = await _dio.post(
        baseUrl + url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: json.encode({
          'name': name,
          'city': city,
          'email': email,
          'phone': phone,
          'address': address,
          'contact_person': contactPerson,
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to add client');
      }
    } catch (e) {
      print('Add Client API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }

  Future<List<Client>> getAllClients(String? search) async {
    try {
      await initializeApiService(); // Ensure token is initialized before getAllClients

      final response = await _dio.get(
        '$baseUrl/all-client',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),

      );

      if (response.statusCode == 200) {
        final data = response.data;
        final clientsJson = data['data']['clients'] as List;
        List<Client> clients = clientsJson.map((json) => Client.fromJson(json)).toList();
        return clients;
      } else {
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      print('Get All Clients API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }


  /////////////////////////////// machine

  Future<Map<String, dynamic>> addMachine({
    required String model_name,
    required String model_code,
  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before addClient

      final url = '/add-machine'; // Adjust endpoint as per your API
      final response = await _dio.post(
        baseUrl + url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: json.encode({
          'model_name': model_name,
          'model_code': model_code,
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to add machine');
      }
    } catch (e) {
      print('Add machine API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }


  Future<List<Machine>> getAllMachines(String? search) async {
    try {
      await initializeApiService(); // Ensure token is initialized before getAllClients

      final response = await _dio.get(
        '$baseUrl/all-machine',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),

      );

      if (response.statusCode == 200) {
        final data = response.data;
        final machineJson = data['data']['machine'] as List;
        List<Machine> machine = machineJson.map((json) => Machine.fromJson(json)).toList();
        return machine;
      } else {
        throw Exception('Failed to load machine');
      }
    } catch (e) {
      print('Get All machine API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }


  ////////////////////////////////////  User


  Future<Map<String, dynamic>> addUser({
    required String name,
    required String email,
    required String phone,
    required String isActive,
    required String userRole,
    required String password,
    required String machineModule,
    required String clientModule,
    required String userModule,
  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before addUser

      final url = '/add-user'; // Adjust endpoint as per your API
      final response = await _dio.post(
        baseUrl + url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: json.encode({
          "name": name,
          "email": email,
          "phone": phone,
          "is_active": isActive,
          "user_role": userRole,
          "password": password,
          "machine_module": machineModule,
          "client_module": clientModule,
          "user_module": userModule,
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      print('Add user API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }


  Future<List<User>> getAllUsers(String? search) async {
    try {
      await initializeApiService(); // Ensure token is initialized before getAllClients

      final response = await _dio.get(
        '$baseUrl/all-user',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final userJson = data['data']['user'] as List;
        List<User> user = userJson.map((json) => User.fromJson(json)).toList();
        return user;
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      print('Get All user API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }

  }


class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("Request to: ${options.uri}");
    print("Request Headers: ${options.headers}");
    print("Request Data: ${options.data}");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("Response from: ${response.requestOptions.uri}");
    print("Response Status: ${response.statusCode}");
    print("Response Headers: ${response.headers}");
    print("Response Data: ${response.data}");
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("Error from: ${err.requestOptions.uri}");
    print("Error Message: ${err.message}");
    if (err.response != null) {
      print("Error Data: ${err.response?.data}");
    }
    return super.onError(err, handler);
  }
}
