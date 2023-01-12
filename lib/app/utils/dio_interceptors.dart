// ignore_for_file: unnecessary_null_in_if_null_operators

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_test/app/settings/endpoints.dart';
import 'package:flutter_app_test/app/settings/keys.dart';
import 'package:get_storage/get_storage.dart';

final storage = GetStorage();

class DioInterceptor extends QueuedInterceptorsWrapper {
  final Dio _dio;
  final Dio _tokenDio = Dio();
  String? _accessToken;

  DioInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.contains(Endpoints.REFRESH_TOKEN)) {
      return handler.next(options);
    }

    _accessToken = storage.read(AppStorageKey.ACCESS_TOKEN) ?? null;
    options.headers.addAll({
      HttpHeaders.authorizationHeader: '${AppStorageKey.TOKEN_TYPE} $_accessToken',
      'platform': 'mobile',
    });
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Assume 401 stands for token expired
    if (err.response?.statusCode == 401) {
      final options = err.response!.requestOptions;
      final authorizationHeader = '${AppStorageKey.TOKEN_TYPE} $_accessToken';
      // If the token has been updated, repeat directly.
      if (authorizationHeader != options.headers[HttpHeaders.authorizationHeader]) {
        options.headers[HttpHeaders.authorizationHeader] = authorizationHeader;
        // Repeat
        _dio.fetch(options).then(
          (r) => handler.resolve(r),
          onError: (e) {
            handler.reject(e);
          },
        );
        return;
      }

      // Request a new token
      String refreshToken = storage.read(AppStorageKey.REFRESH_TOKEN) ?? '';
      if (refreshToken.isEmpty) {
        // Navigate to LOGIN PAGE
        return;
      }
      debugPrint("--[REFRESH TOKEN]--: $refreshToken");
      _tokenDio.get('${Endpoints.REFRESH_TOKEN}/$refreshToken').then((response) async {
        // Get refresh_token from response.data
        // Get access_token from response.data
        _accessToken = 'access_token';
        final authorizationHeader = '${AppStorageKey.TOKEN_TYPE} $_accessToken';
        options.headers[HttpHeaders.authorizationHeader] = authorizationHeader;
        // Save: access_token, refresh_token and expired_time
      }).then((e) {
        // Repeat
        _dio.fetch(options).then(
          (r) => handler.resolve(r),
          onError: (e) {
            handler.reject(e);
          },
        );
      }).onError((error, stackTrace) {
        // Navigate to LOGOUT PAGE
      });
      return;
    }
    return handler.next(err);
  }
}
