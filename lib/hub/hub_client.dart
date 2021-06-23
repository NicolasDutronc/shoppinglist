import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shoppinglist/hub/messages.dart';

class HubClient {
  final String _baseUrl;
  final Dio _dio;
  String _processorId;
  Set<String> _subscribedTopics;

  HubClient(this._baseUrl, this._dio);

  Stream<HubMessage> connect() async* {
    Response<ResponseBody> response;
    response = await _dio.get('$_baseUrl/connect',
        options: Options(responseType: ResponseType.stream));
    print('connecting to hub...');

    yield* response.data.stream.handleError((error, stack) {
      print('An error occured : $error');
      print('stack : $stack');
    }).map((raw) {
      var message = HubMessage.fromJson(jsonDecode(utf8.decode(raw)));
      if (message.type == 'connectionMessage') {
        _processorId = message.msg['processor-id'];
        return null;
      } else {
        return message;
      }
    }).where((msg) => msg != null);
  }

  Future<void> subscribe(String topic) async {
    var response = await _dio.post(
      '$_baseUrl/subscribe',
      data: {'topic': topic, 'processor': _processorId},
      options: Options(responseType: ResponseType.json),
    );

    if (response.statusCode == 200) {
      _subscribedTopics.add(topic);
    }
  }

  Future<void> unsubscribe(String topic) async {
    var response = await _dio.post(
      '$_baseUrl/unsubscribe',
      data: {'topic': topic, 'processor': _processorId},
      options: Options(responseType: ResponseType.json),
    );

    if (response.statusCode == 200) {
      _subscribedTopics.remove(topic);
    }
  }
}
