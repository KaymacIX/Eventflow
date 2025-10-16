import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  late final Dio _dio;
  final String baseUrl;
  static const String _tokenKey = 'auth_token';

  ApiService() : baseUrl = dotenv.env['BASE_URL'] ?? '' {
    if (baseUrl.isEmpty) {
      throw Exception(
        'BASE_URL not found in .env file. Please check your configuration.',
      );
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization token if available
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle errors globally
          return handler.next(error);
        },
      ),
    );
  }

  /// Get stored token from SharedPreferences
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  /// Save token to SharedPreferences
  Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Error saving token: $e');
      return false;
    }
  }

  /// Remove token from SharedPreferences
  Future<bool> removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_tokenKey);
    } catch (e) {
      print('Error removing token: $e');
      return false;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Standard GET request
  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Standard POST request with JSON body
  Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Standard PUT request
  Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Standard PATCH request
  Future<ApiResponse> patch(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Standard DELETE request
  Future<ApiResponse> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Multipart form data request (for file uploads)
  Future<ApiResponse> postMultipart(
    String path, {
    required Map<String, dynamic> data,
    List<MapEntry<String, File>>? files,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData();

      // Add regular fields
      data.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Add files with proper MIME type detection
      if (files != null) {
        for (var fileEntry in files) {
          final file = fileEntry.value;
          final fileName = file.path.split('/').last;
          
          // Get MIME type from file extension
          final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
          final mediaType = MediaType.parse(mimeType);
          
          print('Uploading file: $fileName with MIME type: $mimeType');
          
          formData.files.add(
            MapEntry(
              fileEntry.key,
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: mediaType,
              ),
            ),
          );
        }
      }

      print('FormData fields: ${formData.fields.length}');
      print('FormData files: ${formData.files.length}');

      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// PUT Multipart form data request
  Future<ApiResponse> putMultipart(
    String path, {
    required Map<String, dynamic> data,
    List<MapEntry<String, File>>? files,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData();

      // Add regular fields
      data.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Add files with proper MIME type detection
      if (files != null) {
        for (var fileEntry in files) {
          final file = fileEntry.value;
          final fileName = file.path.split('/').last;
          
          // Get MIME type from file extension
          final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
          final mediaType = MediaType.parse(mimeType);
          
          print('Uploading file: $fileName with MIME type: $mimeType');
          
          formData.files.add(
            MapEntry(
              fileEntry.key,
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: mediaType,
              ),
            ),
          );
        }
      }

      final response = await _dio.put(
        path,
        data: formData,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Handle successful responses
  ApiResponse _handleResponse(Response response) {
    try {
      final data = response.data;

      // Handle case where response.data might not be a Map
      if (data is! Map<String, dynamic>) {
        return ApiResponse(
          success: response.statusCode == 200 || response.statusCode == 201,
          responseCode: response.statusCode ?? 200,
          responseMessage: 'Success',
          responseData: data,
        );
      }

      return ApiResponse(
        success: data['success'] ?? true,
        responseCode: data['response_code'] ?? response.statusCode ?? 200,
        responseMessage: data['response_message'] ?? 'Success',
        responseData: data['response_data'],
      );
    } catch (e) {
      print('Error handling response: $e');
      return ApiResponse(
        success: false,
        responseCode: 500,
        responseMessage: 'Error parsing response',
        responseData: null,
      );
    }
  }

  /// Handle errors
  ApiResponse _handleError(dynamic error) {
    print('API Error: $error');
    
    if (error is DioException) {
      print('DioException type: ${error.type}');
      print('DioException message: ${error.message}');
      print('DioException response: ${error.response}');

      if (error.response != null) {
        try {
          final data = error.response!.data;
          final statusCode = error.response!.statusCode ?? 500;
          
          // Handle Laravel validation errors (422 status code)
          if (statusCode == 422 && data is Map<String, dynamic>) {
            String errorMessage = 'Validation failed';
            
            // Check for Laravel validation error format
            if (data.containsKey('message')) {
              errorMessage = data['message'];
            }
            
            // Get detailed errors if available
            if (data.containsKey('errors') && data['errors'] is Map) {
              final errors = data['errors'] as Map<String, dynamic>;
              final errorsList = <String>[];
              
              errors.forEach((field, messages) {
                if (messages is List) {
                  errorsList.addAll(messages.map((m) => m.toString()));
                } else {
                  errorsList.add(messages.toString());
                }
              });
              
              if (errorsList.isNotEmpty) {
                errorMessage = errorsList.join(', ');
              }
            }
            
            return ApiResponse(
              success: false,
              responseCode: statusCode,
              responseMessage: errorMessage,
              responseData: data['errors'],
            );
          }
          
          // Handle standard API response format
          if (data is Map<String, dynamic>) {
            return ApiResponse(
              success: false,
              responseCode:
                  data['response_code'] ?? statusCode,
              responseMessage: data['response_message'] ??
                  data['message'] ??
                  error.message ??
                  'An error occurred',
              responseData: data['response_data'] ?? data['errors'],
            );
          }
          
          return ApiResponse(
            success: false,
            responseCode: statusCode,
            responseMessage: error.message ?? 'An error occurred',
            responseData: null,
          );
        } catch (e) {
          print('Error parsing error response: $e');
        }
      }

      // Network error
      return ApiResponse(
        success: false,
        responseCode: 0,
        responseMessage: _getErrorMessage(error.type),
        responseData: null,
      );
    }

    return ApiResponse(
      success: false,
      responseCode: 500,
      responseMessage: 'An unexpected error occurred: ${error.toString()}',
      responseData: null,
    );
  }

  String _getErrorMessage(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.badResponse:
        return 'Server error occurred';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'An error occurred';
    }
  }
}

/// Response model matching your PHP trait structure
class ApiResponse {
  final bool success;
  final int responseCode;
  final String responseMessage;
  final dynamic responseData;

  ApiResponse({
    required this.success,
    required this.responseCode,
    required this.responseMessage,
    this.responseData,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      responseCode: json['response_code'] ?? 500,
      responseMessage: json['response_message'] ?? '',
      responseData: json['response_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'response_code': responseCode,
      'response_message': responseMessage,
      'response_data': responseData,
    };
  }
}