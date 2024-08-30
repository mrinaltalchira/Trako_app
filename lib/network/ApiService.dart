import 'dart:convert';
import 'dart:io';

import 'package:Trako/model/all_clients.dart';
import 'package:Trako/model/all_machine.dart';
import 'package:Trako/model/all_supply.dart';
import 'package:Trako/model/all_user.dart';
import 'package:Trako/model/client_report.dart';
import 'package:Trako/model/dashboard.dart';
import 'package:Trako/model/supply_fields_data.dart';
import 'package:Trako/model/user_profie.dart';
import 'package:Trako/pref_manager.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/authFlow/signin.dart';
import '../screens/customer_acknowledgement/client_acknowledgement.dart';
import '../screens/toner_request/toner_request.dart';


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
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print("Error from: ${err.requestOptions.uri}");
    print("Error Message: ${err.message}");
    if (err.response != null) {
      print("Error Data: ${err.response?.data['message']}");

      final errorData = err.response?.data;
      if (err.response?.statusCode == 401 && errorData is Map<String, dynamic>) {

        if (errorData['error'] == 'Unauthorized' || errorData['message'] == 'Invalid token') {

          navigateToAuthProcess();
        }
      }
    }
    return super.onError(err, handler);
  }

  void navigateToAuthProcess() {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AuthProcess()),
          (Route<dynamic> route) => false,
    );
  }

}


class ApiService {

  // final String baseUrl = 'https://trako.tracesci.in/api';
  final String baseUrl = 'http://192.168.2.169:8080/api';
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

      // Create a custom HttpClientAdapter that disables SSL verification
      final httpClientAdapter = DefaultHttpClientAdapter();
      httpClientAdapter.onHttpClientCreate = (client){
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return null;
      };

      _dio = Dio(options);
      _dio.httpClientAdapter = httpClientAdapter;
      _dio.interceptors.add(LoggerInterceptor());
    } catch (e) {
      print('Failed to initialize ApiService: $e');
      throw Exception('Failed to initialize ApiService');
    }
  }

  Future<List<AcknowledgementItem>> getAllAcknowledgements(String? search) async {
    // Simulated delay to mimic network request
    await Future.delayed(Duration(seconds: 2));

    // Simulated data
    List<AcknowledgementItem> acknowledgements = [
      AcknowledgementItem(
        id: '1',
        name: 'Acknowledgment 1',
        description: 'This is the first acknowledgment.',
        date: '2024-08-28',
        isAcknowledged: true,
      ),
      AcknowledgementItem(
        id: '2',
        name: 'Acknowledgment 2',
        description: 'This is the second acknowledgment.',
        date: '2024-08-27',
        isAcknowledged: false,
      ),
      AcknowledgementItem(
        id: '3',
        name: 'Acknowledgment 3',
        description: 'This is the third acknowledgment.',
        date: '2024-08-26',
        isAcknowledged: true,
      ),
    ];

    // If there's a search query, filter the list based on the name or description
    if (search != null && search.isNotEmpty) {
      acknowledgements = acknowledgements.where((item) {
        return item.name.toLowerCase().contains(search.toLowerCase()) ||
            item.description.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }

    return acknowledgements;
  }

  Future<Toner> getAllToners(String? search) async {
    try {
      await initializeApiService(); // Ensure token is initialized before getAllClients

      final response = await _dio.get(
        '$baseUrl/get-profile',
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
        Toner userResponse = Toner.fromJson(data);
        return userResponse;
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print('Get User Profile API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }

  //////////////////////////////// AUTH

  Future<UserResponse> getProfile(String? search) async {
    try {
      await initializeApiService(); // Ensure token is initialized before getAllClients

      final response = await _dio.get(
        '$baseUrl/get-profile',
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
        UserResponse userResponse = UserResponse.fromJson(data);
        return userResponse;
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print('Get User Profile API error: $e');
      throw Exception('Failed to connect to the server.');
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
    required String isActive,
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
          "isActive": isActive,
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


  Future<Map<String, dynamic>> updateClient({
    required String id,
    required String name,
    required String city,
    required String email,
    required String phone,
    required String address,
    required String contactPerson,
    required String isActive,
  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before addClient

      final url = '/update-client'; // Adjust endpoint as per your API
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
          "isActive": isActive,
          'address': address,
          'contact_person': contactPerson,
          'id':id
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
    required String isActive,
    required String client_name, required String toner_receive_time,
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
          'client_name' : client_name,
          'toner_receive_time':toner_receive_time,
          'isActive': isActive,
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



  Future<Map<String, dynamic>> updateMachine({
    required String id,
    required String model_name,
    required String model_code,
    required String isActive, required String client_name, required String toner_receive_time,


  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before addClient

      final url = '/update-machine'; // Adjust endpoint as per your API
      final response = await _dio.post(
        baseUrl + url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: json.encode({
          'id':id,
          'model_name': model_name,
          'model_code': model_code,
          'client_name' : client_name,
          'toner_receive_time':toner_receive_time,
          'isActive': isActive,
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
    required String userModule, required String supplyChainModule,
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
          "supply_chain_module": supplyChainModule,

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

  Future<Map<String, dynamic>> updateUser({
    required String name,
    required String user_id,
    required String email,
    required String phone,
    required String isActive,
    required String userRole,
    required String password,
    required String machineModule,
    required String clientModule,
    required String userModule,
    required String supplyChainModule,
  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before addUser

      final url = '/update-user'; // Adjust endpoint as per your API
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
          "user_id":user_id,
          "email": email,
          "phone": phone,
          "is_active": isActive,
          "user_role": userRole,
          "password": password,
          "machine_module": machineModule,
          "client_module": clientModule,
          "user_module": userModule,
          "supply_chain_module": supplyChainModule,
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update user');
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

  ////////////////////////////////////   Supply

  Future<Map<String, dynamic>> addSupply({
    required String dispatch_receive,
    required String client_name,
    required String client_city,
    required String model_no,
    required String client_id,
    required String date_time,
    required String qr_code,
    String? reference,
  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before addClient

      final url = '/add-supply'; // Adjust endpoint as per your API
      final response = await _dio.post(
        baseUrl + url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: json.encode({
          "dispatch_receive": dispatch_receive,
          "client_name": client_name,
          "client_city": client_city, // Add this
          "model_no": model_no,
          "client_id": client_id,
          "date_time": date_time,
          "qr_code": qr_code,
          if (reference!= null && reference.isNotEmpty) 'reference': reference,
        }),
      );

      if (response.statusCode == 200) {
        return response.data?? {}; // Return an empty map if response.data is null
      } else {
        throw Exception('Failed to add supply');
      }
    } catch (e) {
      print('Add supply API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }

  Future<SupplySpinnerResponse> getSpinnerDetails() async {
    try {
      await initializeApiService(); // Ensure token is initialized before getAllClients

      final response = await _dio.get(
        '$baseUrl/get-spinner-details',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return SupplySpinnerResponse.fromJson(data);
      } else {
        throw Exception('Failed to load spinner details');
      }
    } catch (e) {
      print('Get All spinner details API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }

  Future<List<Supply>> getAllSupply(String? search) async {
    try {
      await initializeApiService(); // Ensure token is initialized before getAllClients

      final response = await _dio.get(
        '$baseUrl/all-supply',
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
        final supplyJson = data['data']['supply'] as List;
        List<Supply> supply = supplyJson.map((json) => Supply.fromJson(json)).toList();
        return supply;
      } else {
        throw Exception('Failed to load supply');
      }
    } catch (e) {
      print('Get All supply API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }


///////////////////////////////// Client Report

  Future<ClientReportResponse> getReport({
    required String client_id,
    required String to_date,
    required String from_date,
  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before addClient

      final url = '/get-report'; // Adjust endpoint as per your API
      final response = await _dio.get(
        baseUrl + url,
        queryParameters: {
          'client_id': client_id,
          'from_date': from_date,
          'to_date': to_date,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Parse the response data into ClientReportResponse
        var responseData = response.data;
        var clientReportResponse = ClientReportResponse.fromJson(responseData);
        return clientReportResponse;
      } else {
        throw Exception('Failed to get report');
      }
    } catch (e) {
      print('GET REPORT API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }


///////////////////////////////// Dashboard

  Future<DashboardResponse> getDashboard() async {
    try {
      await initializeApiService(); // Ensure token is initialized before making API calls

      final url = '/get-dashboard'; // Adjust endpoint as per your API
      final response = await _dio.get(
        baseUrl + url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Parse the response data into DashboardResponse
        var responseData = response.data;
        var dashboardResponse = DashboardResponse.fromJson(responseData);
        return dashboardResponse;
      } else if(response.statusCode == 401){
        throw Exception('Failed to fetch dashboard details');
      }else {
        throw Exception('Failed to fetch dashboard details');
      }
    } catch (e) {
      print('GET Dashboard API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }


}



