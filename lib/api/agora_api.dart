import 'dart:convert';

import 'package:http/http.dart' as http;

class AgoraApi {
  Future<Map<String, dynamic>> getToken2(String channel, int role) async {
    final String url =
        'https://agora-token.txdevs.com/suoni?channel=$channel&role=$role';
    http.Response _res = await http.get(Uri.parse(url));
    if (_res.statusCode == 200) return jsonDecode(_res.body);
    throw _res.statusCode.toString();
  }
}
