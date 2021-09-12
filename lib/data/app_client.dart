import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player_example/domain/exceptions.dart';

class AppClient {
  final _baseUrl = 'https://api.com/';

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      // final response = await http.get(Uri.parse(_baseUrl + url));
      final response = stubWorkoutResponse;
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        debugPrint(responseJson.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  final stubWorkoutResponse = http.Response("""{
  "exercises": [{"title":"Front lunge","url":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/front_lunge/playlist.m3u8","thumbnail":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/front_lunge/thumbnail.jpg","duration":10,"delay":5},
  {"title":"Hip circles","url":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/hip_circles/playlist.m3u8","thumbnail":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/hip_circles/thumbnail.jpg","duration":10,"delay":3},
  {"title":"Pike stretch","url":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/pike_stretch/playlist.m3u8","thumbnail":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/pike_stretch/thumbnail.jpg","duration":10,"delay":3},
  {"title":"Rest","url":"assets/rest/rest.mp4","thumbnail":"assets/rest/thumbnail.jpg","duration":15,"delay":0},
  {"title":"Front lunge","url":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/front_lunge/playlist.m3u8","thumbnail":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/front_lunge/thumbnail.jpg","duration":10,"delay":5},
  {"title":"Hip circles","url":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/hip_circles/playlist.m3u8","thumbnail":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/hip_circles/thumbnail.jpg","duration":10,"delay":3},
  {"title":"Pike stretch","url":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/pike_stretch/playlist.m3u8","thumbnail":"https://raw.githubusercontent.com/1x3x3x7/m3u8_samples/main/pike_stretch/thumbnail.jpg","duration":10,"delay":3}]
}
""", 200);
}
