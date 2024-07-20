import 'dart:async';
import 'dart:convert';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:suja_shoie_app/feature/data/core/api_constant.dart';
import 'package:suja_shoie_app/feature/data/model/request_data_model.dart';

import '../../../constant/utils/exception/network_exception.dart';


class LoginClient {
  ApiConstant apiConstant=ApiConstant();
  Future<dynamic> post(String loginId, String password) async {
    ApiRequestDataModel requestData = ApiRequestDataModel(
        apiFor: "generate_access_token",
        loginPassword: password,
        clGroup: "patienttype",
        loginId: loginId);

    const timeoutDuration = Duration(seconds: 10);
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstant.baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestData.toJson()),
          )
          .timeout(timeoutDuration);

      // print(response.body);

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        // print('jsonDecode Response Body: ${responseJson}');
      
        final responseMsg = responseJson['response_msg'];
        if (responseMsg != "Login access denied") {
          return responseJson;
        } else {
          throw http.ClientException("Invalid Username or Password");
        }
      } else {
        throw http.ClientException(
            'Failed to Login, status code: ${response.statusCode}');
        // Throw a specific exception for non-200 status codes
      }
    } on TimeoutException {
      throw ("Sorry, the request took too long to process. Please try again later.");
    } catch (e) {
      //  print(e);
      if (e is SocketException) {
        throw NetworkException(
            'Failed to connect to the server. Please check your network connection.');
      } else if (e is http.ClientException) {
        rethrow; 
      }
    }
  }
}
