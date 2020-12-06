import 'package:http/http.dart' as http;
import 'package:news_app/network/custom_exception.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {
 static final String baseUrl   = "https://newsapi.org/v2/";
  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      print("REQUEST ==> ${baseUrl + url} \n");

      final response = await http.get(baseUrl + url);

      responseJson = my_response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> post(String url,dynamic data) async {
    print("REQUEST ==> ${baseUrl + url} \n"+data.toString());
    var responseJson;
    try {
      final response = await http.post(baseUrl + url,body: data,headers: {"Content-Type":"application/x-www-form-urlencoded"});
      print("RESPONSE <== ${baseUrl + url} \n"+response.toString());

      responseJson = my_response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

static  dynamic my_response(http.Response response) {
    print(response);
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
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
}