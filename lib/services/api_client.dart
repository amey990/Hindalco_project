import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

import 'api_config.dart';
import 'token_storage_service.dart';

class ApiClient {
  ApiClient({http.Client? client, TokenStorageService? tokenStorage})
    : _client = client ?? http.Client(),
      _tokenStorage = tokenStorage ?? TokenStorageService();

  final http.Client _client;
  final TokenStorageService _tokenStorage;

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final response = await _client.get(
      _uri(endpoint, queryParams),
      headers: await _headers(),
    );
    return _handleJsonResponse(response);
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await _client.post(
      _uri(endpoint),
      headers: await _headers(includeJsonContentType: true),
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _handleJsonResponse(response);
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await _client.put(
      _uri(endpoint),
      headers: await _headers(includeJsonContentType: true),
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _handleJsonResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await _client.delete(
      _uri(endpoint),
      headers: await _headers(),
    );
    return _handleJsonResponse(response);
  }

  Future<dynamic> multipartPost(
    String endpoint, {
    required String fileField,
    required String filePath,
    Map<String, String>? fields,
  }) async {
    final request = http.MultipartRequest('POST', _uri(endpoint));
    request.headers.addAll(await _headers());
    request.fields.addAll(fields ?? <String, String>{});
    request.files.add(
      await http.MultipartFile.fromPath(
        fileField,
        filePath,
        contentType: _imageContentType(filePath),
      ),
    );

    final streamedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    return _handleJsonResponse(response);
  }

  MediaType _imageContentType(String filePath) {
    final normalizedPath = filePath.toLowerCase();
    if (normalizedPath.endsWith('.jpg') ||
        normalizedPath.endsWith('.jpeg')) {
      return MediaType('image', 'jpeg');
    }
    if (normalizedPath.endsWith('.png')) {
      return MediaType('image', 'png');
    }
    if (normalizedPath.endsWith('.webp')) {
      return MediaType('image', 'webp');
    }

    final mimeType = lookupMimeType(filePath) ?? '';
    return switch (mimeType) {
      'image/jpeg' || 'image/jpg' => MediaType('image', 'jpeg'),
      'image/png' => MediaType('image', 'png'),
      'image/webp' => MediaType('image', 'webp'),
      _ => _fallbackImageContentType(filePath),
    };
  }

  MediaType _fallbackImageContentType(String filePath) {
    final fileName = filePath.split(RegExp(r'[\\/]')).last;
    if (!fileName.contains('.')) {
      return MediaType('image', 'jpeg');
    }

    throw Exception(
      'Only JPG, PNG, and WEBP images are allowed. '
      'Please capture or select another image.',
    );
  }

  Future<String> downloadFile(
    String endpoint,
    String saveFileName, {
    Map<String, String>? queryParams,
  }) async {
    final response = await _client.get(
      _uri(endpoint, queryParams),
      headers: await _headers(),
    );

    if (!_isSuccess(response.statusCode)) {
      throw Exception(_errorMessage(response));
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}${Platform.pathSeparator}$saveFileName',
    );
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  Uri _uri(String endpoint, [Map<String, String>? queryParams]) {
    final normalizedEndpoint =
        endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final uri = Uri.parse('${ApiConfig.baseUrl}$normalizedEndpoint');
    return queryParams == null || queryParams.isEmpty
        ? uri
        : uri.replace(queryParameters: queryParams);
  }

  Future<Map<String, String>> _headers({
    bool includeJsonContentType = false,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      if (includeJsonContentType) 'Content-Type': 'application/json',
    };

    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  dynamic _handleJsonResponse(http.Response response) {
    if (_isSuccess(response.statusCode)) {
      return _decodeJson(response.body);
    }

    throw Exception(_errorMessage(response));
  }

  bool _isSuccess(int statusCode) {
    return statusCode == 200 || statusCode == 201;
  }

  dynamic _decodeJson(String body) {
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }
    return jsonDecode(body);
  }

  String _errorMessage(http.Response response) {
    final fallback = 'Request failed with status ${response.statusCode}';

    try {
      final decoded = _decodeJson(response.body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'] ?? decoded['error'];
        if (message != null && message.toString().trim().isNotEmpty) {
          return message.toString();
        }
      }
    } on FormatException {
      if (response.body.trim().isNotEmpty) {
        return response.body;
      }
    }

    return fallback;
  }
}
