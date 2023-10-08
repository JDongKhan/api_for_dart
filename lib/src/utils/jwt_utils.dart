import 'dart:convert';

import 'package:crypto/crypto.dart';

/// 或者可以使用 三方库 dart_jsonwebtoken: ^2.11.0
class JwtUtils {
  ///生成JWT token
  static String encode(Map<String, dynamic> payload, String secret) {
    final header = jsonEncode({'alg': 'HS256', 'typ': 'JWT'});
    final base64Header = base64Url.encode(utf8.encode(header));
    final base64Payload = base64Url.encode(jsonEncode(payload).codeUnits);
    final signatureInput = '$base64Header.$base64Payload';
    final signature = base64Url.encode(Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(signatureInput)).bytes);
    final jwtToken = '$base64Header.$base64Payload.$signature';
    return jwtToken;
  }

  ///解析jwt token
  static Map<String, dynamic> decode(String jwtToken) {
    final parts = jwtToken.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT Token');
    }
    final header = _decodeJwtPart(parts[0]);
    final payload = _decodeJwtPart(parts[1]);
    return {'header': header, 'payload': payload};
  }

  static Map<String, dynamic>? tryDecode(String token) {
    try {
      return decode(token);
    } catch (error) {
      return null;
    }
  }

  ///验证 jwt token 有效性
  static bool verifyJwtToken(String jwtToken, String secret) {
    final parts = jwtToken.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT Token');
    }
    final header = _decodeJwtPart(parts[0]);
    final payload = _decodeJwtPart(parts[1]);
    final signature = base64Url.decode(parts[2]);
    final signatureInput = '${parts[0]}.${parts[1]}';
    final expectedSignature = Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(signatureInput)).bytes;
    return _constantTimeEquality(signature, expectedSignature);
  }

  static bool isExpired(String token) {
    final expirationDate = getExpirationDate(token);
    // If the current date is after the expiration date, the token is already expired
    return DateTime.now().isAfter(expirationDate);
  }

  static DateTime getExpirationDate(String token) {
    final decodedToken = decode(token);
    Map payload = decodedToken['payload'];
    final expirationDate = DateTime.fromMillisecondsSinceEpoch(0).add(Duration(seconds: payload['exp'].toInt()));
    return expirationDate;
  }

  static Duration getTokenTime(String token) {
    final decodedToken = decode(token);
    Map payload = decodedToken['payload'];
    final issuedAtDate = DateTime.fromMillisecondsSinceEpoch(0).add(Duration(seconds: payload["iat"]));
    return DateTime.now().difference(issuedAtDate);
  }

  static bool _constantTimeEquality(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }

    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }

    return result == 0;
  }

  static dynamic _decodeJwtPart(String part) {
    // final normalizedPayload = base64.normalize(part);
    final decoded = base64Url.decode(part);
    final decodedString = utf8.decode(decoded);
    final decodedJson = jsonDecode(decodedString);
    return decodedJson;
  }
}
