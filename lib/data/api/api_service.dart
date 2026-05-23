import 'dart:convert';
import 'package:http/http.dart' as http;

/// URL base da API. Em produção, altere para o IP/domínio real do servidor.
/// Para emulador Android: use http://10.0.2.2:8080
/// Para dispositivo físico ou iOS simulator na mesma rede: use o IP local, ex.: http://192.168.x.x:8080
const String kBaseUrl = 'http://10.0.2.2:8080';

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
