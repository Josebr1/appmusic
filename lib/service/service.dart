import 'dart:convert';
import 'dart:io';

import 'package:appmusic/service/base_service.dart';
import 'package:appmusic/utils/app_exception.dart';
import 'package:http/http.dart' as http;

class Service extends BaseService {

  @override
  Future getResponse(String query) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(mediaBaseUrl + query));
      responseJson = returnResponse(response);

    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch(response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException("Error occurred while communication with server status code: ${response.statusCode}");
    }
  }
}