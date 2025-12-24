import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(
          BaseOptions(
            // Web uses localhost, Android Emulator uses 10.0.2.2
            baseUrl: kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
            headers: {'Content-Type': 'application/json'},
          ),
        );
}