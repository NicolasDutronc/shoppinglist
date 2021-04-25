import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shoplist/hub/messages.dart';

class HubClient {
  final String _baseUrl;
  final Dio _dio;
  String _processorId;
  List<String> _subscribedTopics;

  HubClient(this._baseUrl, this._dio);

  Stream<HubMessage> Connect() async* {
    Response<ResponseBody> response;
    response = await _dio.get('$_baseUrl/connect',
        options: Options(responseType: ResponseType.stream));
    print('connecting...');

    yield* response.data.stream.map((raw) {
      var message = HubMessage.fromJson(jsonDecode(utf8.decode(raw)));
      if (message.type == 'connectionMessage') {
        _processorId = message.msg['processor-id'];
      } else {
        return message;
      }
    }).handleError((error, stack) {
      print('An error occured : $error');
      print('stack : $stack');
    });
  }
}
