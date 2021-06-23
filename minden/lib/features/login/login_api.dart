import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> login({required String id, required String password}) async {
  final headers = {
    'content-type': 'application/json',
    'x-client-id': '5vf80b3tln2q7ge87af1vtcutc'
  };
  final body = json.encode({'loginId': id, 'password': password});

  final url = Uri.parse(
      'https://bgzprevlv9.execute-api.ap-northeast-1.amazonaws.com/dev/auth');
  final response = await http.post(url, headers: headers, body: body);
  return json.decode(response.body.toString());
}

// curl -v -X POST -H 'x-client-id:5vf80b3tln2q7ge87af1vtcutc' -H 'accept:application/json'  -H "Content-Type: application/json" -d '{"loginId":"nakajo@minden.co.jp", "password":"1234qwer"}' https://bgzprevlv9.execute-api.ap-northeast-1.amazonaws.com/dev/auth
