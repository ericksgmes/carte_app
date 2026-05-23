import 'api_service.dart';

class UserDto {
  final String id;
  final String email;
  final String name;

  const UserDto({required this.id, required this.email, required this.name});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }
}

class UserApi {
  final ApiService _api;

  UserApi(this._api);

  /// Upsert por email: cria ou retorna usuário existente.
  Future<UserDto> loginOrCreate({
    required String name,
    required String email,
  }) async {
    final body = await _api.post('/api/users/login', {
      'name': name,
      'email': email,
    });
    return UserDto.fromJson(body as Map<String, dynamic>);
  }
}
