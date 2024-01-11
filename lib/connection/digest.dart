import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DigestAuth {
  String url;
  String uri;
  String? username;
  String? password;
  String? method = 'GET';

  DigestAuth(
      {required this.url, required this.uri, this.username, this.password});

  Future<void> get() async {
    /// Fazendo a primeira requisição para capturar o cabeçalho www-authenticate
    final client = http.Client();
    final response = await client.get(Uri.parse("$url$uri"));

    /// Verificando se há o cabeçalho www-authenticate
    if (!response.headers.keys.contains('www-authenticate')) {
      throw Exception('No www-authenticate header in response');
    }

    /// Gerando o cabeçalho Authorization
    final String authorization =
        _generateAuthorizationString(response.headers['www-authenticate']!);

    /// Fazendo a segunda requisição com o cabeçalho Authorization
    final response2 = await client
        .get(Uri.parse("$url$uri"), headers: {'Authorization': authorization});

    if (kDebugMode) {
      print('HEADERS RECEBIDO: ${response.headers['www-authenticate']}');
      print(response2.request);
      print('Authorization enviado:$authorization');
      print(response2.body);
    }
  }

  ///
  ///
  ///
  String _generateAuthorizationString(String authenticate) {
    final Map<String, String> map = _parseAuthenticateToMap(authenticate);
    String nc = '1'.padLeft(8, '0');

    /// TODO(manoel): Implementar o nonce como um valor aleatório
    String cnonce = '45c1e68d0a40e49f';
    var a1 = md5Hash("$username:${map['realm']}:$password");
    var a2 = md5Hash("$method:$uri");

    var response = md5Hash("$a1:${map['nonce']}:$nc:$cnonce:${map['qop']}:$a2");

    String digestHeaderString =
        'Digest username="$username", realm="${map['realm']}", nonce="${map['nonce']}", uri="$uri", response="$response", qop=${map['qop']}, nc=$nc, cnonce="$cnonce"';

    return digestHeaderString;
  }

  ///
  ///
  ///
  Map<String, String> _parseAuthenticateToMap(String authenticate) {
    final Map<String, String> map = {};

    /// Removendo o Digest do cabeçalho
    final String digest = authenticate.substring(7);

    /// Removendo as aspas
    final String noQuotes = digest.replaceAll('"', '');

    /// Removendo os espaços
    final String noSpaces = noQuotes.replaceAll(' ', '');

    /// Separando os valores
    final List<String> values = noSpaces.split(',');

    /// Separando as chaves e os valores
    for (final String value in values) {
      final List<String> keyValue = value.split('=');
      map[keyValue[0]] = keyValue[1];
    }
    return map;
  }

  ///
  ///
  ///
  String md5Hash(String data) {
    var content = const Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content).toString();
    return digest;
  }
}
