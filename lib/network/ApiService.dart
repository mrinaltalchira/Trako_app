import 'dart:convert';
import 'dart:io';

import 'package:Trako/globals.dart';
import 'package:Trako/model/all_clients.dart';
import 'package:Trako/model/all_machine.dart';
import 'package:Trako/model/all_supply.dart';
import 'package:Trako/model/all_toner_request.dart';
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
import '../model/acknowledgment.dart';
import '../model/machines_by_client_id.dart';
import '../model/toner_colors.dart';
import '../screens/authFlow/signin.dart';
import '../screens/customer_acknowledgement/client_acknowledgement.dart';
import '../screens/toner_request/add_request.dart';
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

  final String baseUrl = 'https://trako.tracesci.in/api';
     // final String baseUrl = 'http://192.168.2.125:8000/api';

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
       } on DioException catch (e) {
         // Handle Dio specific errors with response data if available
         if (e.response != null && e.response!.data is Map<String, dynamic>) {
           print('Login API error: ${e.response!.data}');
           return e.response!.data as Map<String, dynamic>;
         } else {
           print('Login API error: $e');
           return {
             'success': false,
             'message': e.message ?? 'Network error occurred',
             'status': e.response?.statusCode ?? 500
           };
         }
       } catch (e) {
         print('Login API error: $e');
         return {
           'success': false,
           'message': 'Connection failed. Please check your internet connection.',
           'status': 500
         };
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
       required String password,
       required String isActive,
       required String machines,
     }) async {
       try {
         await initializeApiService(); // Ensure token is initialized

         final url = '/add-client';
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
             'isActive': isActive,
             'address': address,
             'contact_person': contactPerson,
             'machines': machines,
             'password': password
           }),
         );

         // Handle all possible response codes
         if (response.statusCode == 200) {
           final responseData = response.data;
           // Check for success flag in response
           if (responseData['success'] == false) {
             throw ApiException(
               responseData['message'] ?? 'Failed to add client',
               responseData['status'] ?? 400,
             );
           }
           return responseData;
         } else {
           throw ApiException('Server error: ${response.statusCode}', response.statusCode ?? 500);
         }
       } on DioException catch (e) {
         if (e.response != null) {
           final errorData = e.response!.data;
           throw ApiException(
             errorData['message'] ?? 'Error connecting to server',
             e.response!.statusCode ?? 500,
           );
         } else {
           throw ApiException('Network error: ${e.message}', 0);
         }
       } catch (e) {
         print('Add Client API error: $e');
         throw ApiException('Failed to connect to the server.', 0);
       }
     }

     Future<Map<String, dynamic>> updateClient({
       required String id,
       required String name,
       required String email,
       required String phone,
       required String address,
       required String contactPerson,
       String? password,
       required String isActive,
       required String machines,
     }) async {
       try {
         await initializeApiService();

         final url = '/update-client';
         final Map<String, dynamic> requestData = {
           'name': name,
           'email': email,
           'phone': phone,
           'isActive': isActive,
           'address': address,
           'contact_person': contactPerson,
           'id': id,
           'machines': machines,
         };

         // Only include password if it's provided and not empty
         if (password != null && password.isNotEmpty) {
           requestData['password'] = password;
         }

         final response = await _dio.post(
           baseUrl + url,
           options: Options(
             headers: {
               'Content-Type': 'application/json',
               'Authorization': 'Bearer $token',
             },
           ),
           data: json.encode(requestData),
         );

         if (response.statusCode == 200) {
           final responseData = response.data;
           if (responseData['success'] == false) {
             throw ApiException(
               responseData['message'] ?? 'Failed to update client',
               responseData['status'] ?? 400,
             );
           }
           return responseData;
         } else {
           throw ApiException('Server error: ${response.statusCode}', response.statusCode ?? 500);
         }
       } on DioException catch (e) {
         if (e.response != null) {
           final errorData = e.response!.data;
           throw ApiException(
             errorData['message'] ?? 'Error connecting to server',
             e.response!.statusCode ?? 500,
           );
         } else {
           throw ApiException('Network error: ${e.message}', 0);
         }
       } catch (e) {
         print('Update Client API error: $e');
         throw ApiException('Failed to connect to the server.', 0);
       }
     }


     Future<List<Map<String, dynamic>>> getAllClients({
       String? search,
       String? filter,
       int? perPage,
       int? page,
       String? state,
       String? city,
     }) async {
       try {
         await initializeApiService(); // Ensure token is initialized before calling the API

         final response = await _dio.get(
           '$baseUrl/all-client',
           queryParameters: {
             if (search != null && search.isNotEmpty) 'search': search,
             if (filter != null && filter.isNotEmpty) 'filter': filter,
             if (state != null && state.isNotEmpty) 'state': state,
             if (city != null && city.isNotEmpty) 'city': city,
             if (perPage != null) 'per_page': perPage,
             if (page != null) 'page': page,
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

           // Convert the list of clients to List<Map<String, dynamic>>
           List<Map<String, dynamic>> clients = clientsJson
               .map<Map<String, dynamic>>((json) => Map<String, dynamic>.from(json))
               .toList();

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
    required String serial_no,
    required String isActive,
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
          'model_no': model_name,
          'serial_no': serial_no,
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


     Future<Map<String, dynamic>> addMachineModel({

       required String model_no,
       required String? id,
       required bool isActive,
       required List<String> colors,
     }) async {
       try {
         await initializeApiService(); // Ensure token is initialized before API call

         final url = '/add-Model-no';

         // Create the request data
         Map<String, dynamic> requestData = {
           'model_id': id,
           'model_no': model_no,
           'isActive': isActive,
           'colors': colors.join(','), // Convert list to comma-separated string
         };

         final response = await _dio.post(
           baseUrl + url,
           options: Options(
             headers: {
               'Content-Type': 'application/json',
               'Authorization': 'Bearer $token',
             },
           ),
           data: requestData,
         );

         if (response.statusCode == 200) {
           return response.data;
         } else {
           throw Exception('Failed to add machine model');
         }
       } catch (e) {
         print('Add machine model API error: $e');
         return {
           'error': true,
           'message': 'Failed to connect to the server.',
           'status': 500
         };
       }
     }


     Future<Map<String, dynamic>> softDeleteClient({required String clientId}) async {
       try {
         await initializeApiService(); // Ensure token is initialized before making API requests

         final deleteUrl = '/delete-clients/$clientId'; // Soft delete API endpoint

         final response = await _dio.delete(
           baseUrl + deleteUrl,
           options: Options(
             headers: {
               'Content-Type': 'application/json',
               'Authorization': 'Bearer $token',
             },
           ),
         );

         if (response.statusCode == 200) {
           print('Client soft deleted successfully');
           return response.data;
         } else {
           throw Exception('Failed to soft delete client');
         }
       } catch (e) {
         print('Soft delete API error: $e');
         throw Exception('Failed to connect to the server.');
       }
     }

     Future<Map<String, dynamic>> unassignedSerialFromClient({required String serialNo,required BuildContext context,required String clientId}) async {
       try {
         await initializeApiService(); // Ensure token is initialized before making API requests

         final deleteUrl = '/unassign-machine/$serialNo'; // Soft delete API endpoint

         final response = await _dio.post(
           baseUrl + deleteUrl,
           options: Options(
             headers: {
               'Content-Type': 'application/json',
               'Authorization': 'Bearer $token',
             },
           ),
           data: json.encode({
             'client_id': clientId,
           }),
         );

         if (response.statusCode == 200) {
           print('Client soft deleted successfully');
           return response.data;
         } else {
           showSnackBar(context, response.data.message);
           throw Exception('Failed to soft delete client');
         }
       } catch (e) {
         print('Soft delete API error: $e');
         throw Exception('Failed to connect to the server.');
       }
     }

     Future<Map<String, dynamic>> softDeleteSerialNo({required String serialId}) async {
       try {
         await initializeApiService(); // Ensure token is initialized before making API requests

         final deleteUrl = '/delete-serial/$serialId'; // Soft delete API endpoint

         final response = await _dio.delete(
           baseUrl + deleteUrl,
           options: Options(
             headers: {
               'Content-Type': 'application/json',
               'Authorization': 'Bearer $token',
             },
           ),
         );

         if (response.statusCode == 200) {
           print('Serial soft deleted successfully');
           return response.data;
         } else {
           throw Exception('Failed to soft delete Serial');
         }
       } catch (e) {
         print('Soft delete API error: $e');
         throw Exception('Failed to connect to the server.');
       }
     }

     Future<Map<String, dynamic>> softDeleteModelNo({required String modelId}) async {
       try {
         await initializeApiService(); // Ensure token is initialized before making API requests

         final deleteUrl = '/delete-model/$modelId'; // Soft delete API endpoint

         final response = await _dio.delete(
           baseUrl + deleteUrl,
           options: Options(
             headers: {
               'Content-Type': 'application/json',
               'Authorization': 'Bearer $token',
             },
           ),
         );

         if (response.statusCode == 200) {
           print('Model soft deleted successfully');
           return response.data;
         } else {
           throw Exception('Failed to soft delete model');
         }
       } catch (e) {
         print('Soft delete API error: $e');
         throw Exception('Failed to connect to the server.');
       }
     }


  Future<Map<String, dynamic>> updateMachine({
    required String id,
    required String model_name,
    required String serial_no,
    required String isActive,


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
          'model_no': model_name,
          'serial_no': serial_no,
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

     Future<List<Map<String, dynamic>>> getAllMachines({
       String? search,
       String? filter,
       int? perPage, // Default number of items per page
       int? page,    // Default page number
     }) async {
       try {
         await initializeApiService(); // Ensure token is initialized before calling API

         final response = await _dio.get(
           '$baseUrl/all-machine',
           queryParameters: {
             if (search != null && search.isNotEmpty) 'search': search,
             if (filter != null && filter.isNotEmpty) 'filter': filter,
             if (perPage != null) 'per_page': perPage,
             if (page != null) 'page': page,
           },
           options: Options(
             headers: {
               'Authorization': 'Bearer $token',
             },
           ),
         );

         if (response.statusCode == 200) {
           final data = response.data;
           final machineJson = data['data']['machines'] as List;

           // Convert each item to Map<String, dynamic> directly without using Machine model
           List<Map<String, dynamic>> machines = machineJson
               .map((json) => json as Map<String, dynamic>)
               .toList();

           return machines;
         } else {
           throw Exception('Failed to load machines');
         }
       } catch (e) {
         print('Get All machines API error: $e');
         throw Exception('Failed to connect to the server.');
       }
     }


     Future<Map<String, dynamic>> getAllModels({
       String? search,
       String? filter,
       int? page = 1,
       int? perPage = 20,
     }) async {
       try {
         await initializeApiService(); // Ensure token is initialized before calling API

         final response = await _dio.get(
           '$baseUrl/get-all-model',
           queryParameters: {
             if (search != null && search.isNotEmpty) 'search': search,
             if (filter != null && filter.isNotEmpty) 'filter': filter,
             'per_page': perPage,
             'page': page,
           },
           options: Options(
             headers: {
               'Authorization': 'Bearer $token',
             },
           ),
         );

         if (response.statusCode == 200) {
           // Return the entire response data directly without conversion
           return response.data;
         } else {
           throw Exception('Failed to load machines');
         }
       } catch (e) {
         print('Get All Machines API error: $e');
         return {
           'error': true,
           'message': 'Failed to connect to the server.',
           'data': null
         };
       }
     }


     ////////////////////////////////////  User

     Future<Map<String, dynamic>> addUser(Map<String, String> userData) async {
       try {
         await initializeApiService(); // Ensure token is initialized before addUser

         final url = '/add-user'; // Adjust endpoint as per your API

         // Prepare request data with snake_case keys for API
         final requestData = {
           "name": userData['name'],
           "email": userData['email'],
           "phone": userData['phone'],
           "is_active": userData['isActive'],
           "user_role": userData['userRole'],
           "password": userData['password'] ?? '', // Handle optional password
           "machine_module": userData['machineModule'],
           "client_module": userData['clientModule'],
           "user_module": userData['userModule'],
           "supply_chain_module": userData['supplyChainModule'],
           "acknowledge_module": userData['acknowledgeModule'],
           "toner_request_module": userData['tonerRequestModule'],
           "dispatch_module": userData['dispatchModule'],
           "receive_module": userData['receiveModule'],
         };

         final response = await _dio.post(
           baseUrl + url,
           options: Options(
             headers: {
               'Content-Type': 'application/json',
               'Authorization': 'Bearer $token',
             },
           ),
           data: json.encode(requestData),
         );

         if (response.statusCode == 200) {
           return response.data;
         } else {
           throw Exception('Failed to add user: ${response.statusMessage}');
         }
       } catch (e) {
         debugPrint('Add user API error: $e');
         if (e is DioException) {
           if (e.response != null && e.response!.data != null) {
             return {
               'error': true,
               'status': e.response!.statusCode ?? 500,
               'message': e.response!.data['message'] ?? 'Server error occurred'
             };
           }
         }
         return {
           'error': true,
           'status': 500,
           'message': 'Failed to connect to the server.'
         };
       }
     }

// Also implement the updateUser method for consistency
  Future<Map<String, dynamic>> updateUser(Map<String, String> userData) async {
    try {
      await initializeApiService(); // Ensure token is initialized

      final url = '/update-user'; // Adjust endpoint as per your API

      // Prepare request data with snake_case keys for API
      final requestData = {
        "user_id": userData['user_id'],
        "name": userData['name'],
        "email": userData['email'],
        "phone": userData['phone'],
        "is_active": userData['isActive'],
        "user_role": userData['userRole'],
        "machine_module": userData['machineModule'],
        "client_module": userData['clientModule'],
        "user_module": userData['userModule'],
        "supply_chain_module": userData['supplyChainModule'],
        "acknowledge_module": userData['acknowledgeModule'],
        "toner_request_module": userData['tonerRequestModule'],
        "dispatch_module": userData['dispatchModule'],
        "receive_module": userData['receiveModule'],
      };

      // Only add password if provided
      if (userData.containsKey('password') && userData['password']!.isNotEmpty) {
        requestData["password"] = userData['password'];
      }

      final response = await _dio.post(
        baseUrl + url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update user: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Update user API error: $e');
      if (e is DioException) {
        if (e.response != null && e.response!.data != null) {
          return {
            'error': true,
            'status': e.response!.statusCode ?? 500,
            'message': e.response!.data['message'] ?? 'Server error occurred'
          };
        }
      }
      return {
        'error': true,
        'status': 500,
        'message': 'Failed to connect to the server.'
      };
    }
  }

     Future<List<User>> getAllUsers({String? search, int? perPage, int? page}) async {
       try {
         await initializeApiService(); // Ensure token is initialized before making the API call

         final response = await _dio.get(
           '$baseUrl/all-user',
           queryParameters: {
             if (search != null && search.isNotEmpty) 'search': search,
             if (perPage != null) 'per_page': perPage,
             if (page != null) 'page': page,
           },
           options: Options(
             headers: {
               'Authorization': 'Bearer $token', // Use the initialized token
             },
           ),
         );

         if (response.statusCode == 200) {
           final responseData = response.data;
           final usersJson = responseData['data']['users'] as List<dynamic>; // Adjust based on nested structure

           List<User> users = usersJson
               .map((json) => User.fromJson(json as Map<String, dynamic>))
               .toList();

           return users;
         } else if (response.statusCode == 401) {
           throw Exception('Unauthorized: Invalid token.');
         } else {
           throw Exception('Failed to load user data: ${response.statusCode}');
         }
       } catch (e) {
         print('Get Users API error: $e');
         throw Exception('Failed to connect to the server.');
       }
     }


  ////////////////////////////////////   Supply

  Future<Map<String, dynamic>> addSupply({
    required String supply_type,
    required String client_id,
    required String serial_no,
    required String date_time,
    required String qr_code,
    required int receive_type,
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
          "supply_type": supply_type,
          "serial_no": serial_no,
          "client_id": client_id,
          "date_time": date_time,
          "qr_code": qr_code,
          "receive_type": receive_type,
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


     Future<SupplyResponse> getAllSupply({String? search,String? filter, int page = 1, int perPage = 10}) async {
       try {
         await initializeApiService(); // Ensure token is initialized before making API calls

         final url = '/all-supply'; // Adjust endpoint as per your API
         final response = await _dio.get(
           baseUrl + url,
           queryParameters: {
             if (search != null && search.isNotEmpty) 'search': search,
             'page': page, // Include page parameter for pagination
             'per_page': perPage, // Include per_page parameter for pagination
           },
           options: Options(
             headers: {
               'Content-Type': 'application/json',
               'Authorization': 'Bearer $token',
             },
           ),
         );

         if (response.statusCode == 200) {
           // Parse the response data into SupplyResponse
           var responseData = response.data;
           var supplyResponse = SupplyResponse.fromJson(responseData);
           return supplyResponse;
         } else if (response.statusCode == 401) {
           throw Exception('Unauthorized: Failed to fetch supply details');
         } else {
           throw Exception('Failed to fetch supply details');
         }
       } catch (e) {
         print('GET All Supply API error: $e');
         throw Exception('Failed to connect to the server.');
       }
     }



///////////////////////////////// Client Report

  Future<ClientReportResponse> getReport({
    required String client_id,
    required String from_date,
    required String to_date,
  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before making the API call

      final url = '/get-report'; // Adjust endpoint as per your API

      // Print debugging information
      print('Sending request to: $baseUrl$url');
      print('Query parameters: client_id=$client_id, from_date=$from_date, to_date=$to_date');

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
            'Authorization': 'Bearer $token', // Ensure the token is correctly set
          },
        ),
      );

      // Debugging: Print response details
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Parse the response data into ClientReportResponse
        var responseData = response.data;
        var clientReportResponse = ClientReportResponse.fromJson(responseData);
        return clientReportResponse;
      } else {
        // Provide more detail in the exception message
        throw Exception('Failed to get report. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Print detailed error information
      print('GET REPORT API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }

  Future<Map<String, dynamic>> sendReportOnMail({
    required String client_id,
    required String from_date,
    required String to_date,
  }) async {
    try {
      await initializeApiService();

      final url = '/send-report';

      print('Request to: $baseUrl$url');
      print('Request Data: {client_id: $client_id, from_date: $from_date, to_date: $to_date}');

      final response = await _dio.post(
        baseUrl + url,
        data: {
          'client_id': client_id,
          'from_date': from_date,
          'to_date': to_date,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true, // Accept any status code to handle it ourselves
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'] ?? {},
          'message': response.data['message'] ?? "Report has been sent successfully.",
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': response.data['message'] ?? "No data found for the given period.",
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to send mail. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('SEND REPORT API error: $e');
      return {
        'success': false,
        'message': 'Failed to send mail. Check your connection and try again.',
      };
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

  // addAcknowledgement


  Future<Map<String, dynamic>> addAcknowledgement({
    required String qr_code,
    required String date_time,
    required String? reference
  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before addClient

      final url = '/add-acknowledgement'; // Adjust endpoint as per your API
      final response = await _dio.post(
        baseUrl + url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: json.encode({
          'qr_code': qr_code,
          'date_time': date_time,
          'reference' : reference,
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to add acknowledgement');
      }
    } catch (e) {
      print('Add acknowledgement API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }


  Future<List<AcknowledgementModel>> getAllAcknowledgeList({
    String? search,
    int? perPage, // Number of items per page
    int? page,   // Page number
  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before making the API call

      final response = await _dio.get(
        '$baseUrl/all-acknowledgement',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (perPage != null) 'per_page': perPage,
          if (page != null) 'page': page,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final acknowledgementsJson = data['data']['acknowledgements'] as List;
        List<AcknowledgementModel> acknowledgements = acknowledgementsJson
            .map((json) => AcknowledgementModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return acknowledgements;
      } else {
        throw Exception('Failed to load Acknowledgement data');
      }
    } catch (e) {
      print('Get All Acknowledgement API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }



//      Spinner

  Future<List<Map<String, dynamic>>> getMachineByClientIdList(String clientId) async {
    try {
      await initializeApiService(); // Ensure token is initialized before making the API call

      final response = await _dio.get(
        '$baseUrl/machines/by-client',
        queryParameters: {
          'client_id': clientId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final machinesJson = responseData['data']['machines'] as List<dynamic>;

        // Convert each item to Map<String, dynamic> directly
        List<Map<String, dynamic>> machines = machinesJson
            .map((json) => json as Map<String, dynamic>)
            .toList();

        return machines;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token.');
      } else {
        throw Exception('Failed to load MachineByClientId data: ${response.statusCode}');
      }
    } catch (e) {
      print('Get All MachineByClientId API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }


// REQUEST TONER


  Future<Map<String, dynamic>> sendTonerRequests(List<TonerRequestModel> cart) async {
    try {
      await initializeApiService(); // Ensure token is initialized before sending requests

      final url = '/add-toner-request'; // Adjust endpoint as per your API
      final response = await _dio.post(
        baseUrl + url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: json.encode({
          'toner_requests': cart.map((request) => request.toJson()).toList(),
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      } else {
        // Handle non-successful responses
        print('Unexpected status code: ${response.statusCode}');
        print('Response body: ${response.data}');
        throw Exception('Failed to send toner requests: ${response.statusCode}');
      }
    } catch (e) {
      // Print detailed error information
      print('Send toner requests API error: $e');
      // Throw a more detailed exception
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }

  Future<List<AllTonerRequest>> getAllTonerRequests({
    String? search, // Search query
    int? perPage,   // Number of items per page
    int? page,      // Page number
  }) async {
    try {
      await initializeApiService(); // Ensure token is initialized before making the API call

      final response = await _dio.get(
        '$baseUrl/toner-requests',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (perPage != null) 'per_page': perPage,
          if (page != null) 'page': page,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Use the initialized token
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final tonerRequestsJson = responseData['data']['toner_requests'] as List<dynamic>; // Adjust based on nested structure

        List<AllTonerRequest> tonerRequests = tonerRequestsJson
            .map((json) => AllTonerRequest.fromJson(json as Map<String, dynamic>))
            .toList();

        return tonerRequests;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token.');
      } else {
        throw Exception('Failed to load TonerRequest data: ${response.statusCode}');
      }
    } catch (e) {
      print('Get TonerRequest API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }


  Future<List<TonerColors>> getTonerColors(String modelNo) async {
    try {
      await initializeApiService();

      final url = '$baseUrl/toner-color';
      print('Sending request to: $url with model_id: $modelNo');

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: json.encode({
          'serial_no_id': modelNo,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        final tonerColorsList = responseData['data']['toner_colors'];

        if (tonerColorsList != null && tonerColorsList is List) {
          return tonerColorsList
              .map<TonerColors>((item) => TonerColors.fromJson(item))
              .toList();
        } else {
          print('No toner colors found for the given model ID.');
          return [];
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token.');
      } else {
        throw Exception('Failed to load TonerColors data: ${response.statusCode}');
      }
    } catch (e) {
      print('Get TonerColors API error: $e');
      throw Exception('Failed to connect to the server.');
    }
  }


}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}


