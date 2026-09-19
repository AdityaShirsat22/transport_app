import 'package:dio/dio.dart';
import '../config/env_config.dart';

class ApiClient {
  final Dio dio;

  ApiClient({Dio? client})
      : dio = client ??
            Dio(
              BaseOptions(
                baseUrl: EnvConfig.apiBaseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }
}
