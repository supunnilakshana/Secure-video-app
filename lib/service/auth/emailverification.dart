import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class Emailverification {
  static Future<int> sendcode(String email, String code) async {
    print(email);
    int res = 0;
    final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Access-Control-Allow-Origin': '*',
          'Authorization':
              'Bearer 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',
          "Access-Control-Allow-Origin": "*", // Required for CORS support to w
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
        body: jsonEncode({
          "personalizations": [
            {
              "to": [
                {"email": email}
              ]
            }
          ],
          "from": {"email": "supusdinithi@gmail.com"},
          "subject": "Secure Video Verification Code",
          "content": [
            {"type": "text/plain", "value": "Your verification code is" + code}
          ]
        }),
      );

      print(response.statusCode.toString() + "---------");
      if (response.statusCode == 201 || response.statusCode == 200) {
        res = 1;
        print(response.body);
      } else {}
    } on Exception catch (e) {
      print(e);
    }
    return res;
  }
}
