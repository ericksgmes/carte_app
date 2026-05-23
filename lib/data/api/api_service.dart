import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// URL base da API escolhida por plataforma:
///   Web (Chrome)         → localhost:8080
///   Emulador Android     → 10.0.2.2:8080
///   iOS Simulator / físico na rede → ajuste para o IP da máquina
final String kBaseUrl =
    kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? kBaseUrl,
        _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<dynamic> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await _client.get(uri, headers: _headers);
    _assertOk(res);
    return jsonDecode(res.body);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await _client.post(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );
    _assertOk(res);
    return jsonDecode(res.body);
  }

  void _assertOk(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ApiException(res.statusCode, res.body);
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String body;

  const ApiException(this.statusCode, this.body);

  @override
  String toString() => 'ApiException($statusCode): $body';
}
