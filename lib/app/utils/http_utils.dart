import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_app_test/app/utils/dio_interceptors.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HttpResponse<T> {
  HttpResponse({
    this.body,
    this.headers,
    this.request,
    this.statusCode,
    this.statusMessage,
    this.extra,
  });

  T? body;
  Headers? headers;
  RequestOptions? request;
  int? statusCode;
  String? statusMessage;
  Map<String, dynamic>? extra;
}

class HttpHelper {
  static getDio() {
    Dio dio = Dio();
    dio.interceptors.add(DioInterceptor(dio));
    return dio;
  }

  static Future<HttpResponse> get(String url) async {
    final dio = HttpHelper.getDio();
    final Response response = await dio.get(url);
    return HttpResponse(
      body: response.data,
      headers: response.headers,
      request: response.requestOptions,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response.extra,
    );
  }

  static Future<HttpResponse> post(String url, Object data) async {
    final dio = HttpHelper.getDio();
    final Response response = await dio.post(url, data: data);
    return HttpResponse(
      body: response.data,
      headers: response.headers,
      request: response.requestOptions,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response.extra,
    );
  }

  static Future<HttpResponse> put(String url, Object data) async {
    final dio = HttpHelper.getDio();
    final Response response = await dio.put(url, data: data);
    return HttpResponse(
      body: response.data,
      headers: response.headers,
      request: response.requestOptions,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response.extra,
    );
  }

  static Future<HttpResponse> delete(String url, [Object? data]) async {
    final dio = HttpHelper.getDio();
    final Response response = await dio.delete(url, data: data);
    return HttpResponse(
      body: response.data,
      headers: response.headers,
      request: response.requestOptions,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response.extra,
    );
  }

  static Future<HttpResponse> uploadFile(String url, {required File file}) async {
    final dio = HttpHelper.getDio();
    final uploadFile = await MultipartFile.fromFile(
      file.path,
      filename: basename(file.path),
    );
    final formData = FormData.fromMap({'file': uploadFile});
    final response = await dio.post(url, data: formData);
    return HttpResponse(
      body: response.data,
      headers: response.headers,
      request: response.request,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response.extra,
    );
  }

  static Future<String> downloadFile(
    String url,
    String? savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final Dio dio = HttpHelper.getDio();
    final tempDir = await getApplicationDocumentsDirectory();
    String filename = '';
    //
    return await dio.download(
      url,
      (Headers headers) {
        if (savePath != null) {
          return savePath;
        }
        //
        List<String> tokens = headers.value('content-disposition')!.split(";");
        for (var i = 0; i < tokens.length; i++) {
          if (tokens[i].contains('filename')) {
            filename = tokens[i].substring(tokens[i].indexOf("=") + 1, tokens[i].length);
          }
        }
        filename = Uri.decodeFull(filename).replaceAll("UTF-8''", '');
        return '${tempDir.path}/$filename';
      },
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      options: options,
    ).then(
      (response) {
        return savePath ?? '${tempDir.path}/$filename';
      },
      onError: (e) {
        throw e;
      },
    );
  }

  static String? getUriQueryParam(Uri uri, String key) {
    final queryParams = uri.queryParametersAll.entries.toList();
    if (queryParams.any((_) => _.key == key)) {
      return queryParams.firstWhere((_) => _.key == key).value.first;
    }
    return null;
  }
}
