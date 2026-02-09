import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

final dioProvider = Provider((ref) => DioClient().dio);

class DioClient {
  final Dio dio;
  final _storage = const FlutterSecureStorage();

  DioClient()
      : dio = Dio(BaseOptions(
          baseUrl: 'https://api.fairadda.com/v1', // Production URL
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 1. Attach Auth Token
        final token = await _storage.read(key: 'auth_token');
        if (token != null) options.headers['Authorization'] = 'Bearer $token';

        // 2. Attach Device ID (For Binding Check)
        final deviceId = await _getDeviceId();
        options.headers['X-Device-ID'] = deviceId;

        // 3. Request Signing (HMAC - Simplified for demo)
        // options.headers['X-Signature'] = generateHmacSignature(options.data);

        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Token expired or Session Timeout -> Trigger Logout
          // ref.read(authProvider.notifier).logout();
        }
        return handler.next(e);
      },
    ));
  }

  Future<String> _getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Unique ID
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown_ios';
    }
    return 'unknown_device';
  }
}
