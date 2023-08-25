import 'dart:convert';

import 'package:http/http.dart' as http;

// class AgoraApito {
//   // final String tokenUrl = "http://3.134.106.188:8080/access_token?channelName=";
//   Future<Map<String, String>> getTokenby(int type, String channel) async {
//     var callable = FirebaseFunctions.instance
//         .httpsCallable('createToken', options: HttpsCallableOptions());
//     var res = await callable.call({'role': type, "channelName": 'arena'});
//     return {
//       'token': res.data['data']['token'],
//       'channel': res.data['data']['channelName'],
//     };
//     // Response _res = await get(tokenUrl + channel);
//     // if (_res.statusCode == 200) return _res.body['token'];
//     // throw _res.body;
//   }
// }

class AgoraApi {
  // final String tokenUrl = "http://192.168.0.111:8000/?channel=arena-1&role=1";de
  Future<Map<String, dynamic>> getToken(String channel, int role) async {
    final String url = 'https://agora-token.txdevs.com/suoni?channel=$channel';
    // "http://livearena.aiustack.com/?channel=$channel&role=$role";

    http.Response _res = await http.get(Uri.parse(url));
    if (_res.statusCode == 200) return jsonDecode(_res.body);
    throw _res.statusCode.toString();
  }

  Future<Map<String, dynamic>> getToken2(String channel, int role) async {
    final String url =
        "http://livearena.aiustack.com/?channel=$channel&role=$role";
    http.Response _res = await http.get(Uri.parse(url));
    if (_res.statusCode == 200) return jsonDecode(_res.body);
    throw _res.statusCode.toString();
  }
}
