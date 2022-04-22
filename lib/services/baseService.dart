
import 'dart:convert';

import 'package:demo_app/constants.dart';
import 'package:demo_app/model/opinion_request.dart';
import 'package:demo_app/services/alert.dart';
import 'package:dio/dio.dart';

var dio = Dio();

class BaseApiService {
  static const BASE_URL = Constants.apiUrl;


  static Future save(url, body, context) async {
    try {
      final response = await dio.post(Constants.apiUrl + url, data: body);


      return response.data;
    } on DioError catch (e) {
      print(e);
      print(e.response);
      if (e.response?.data['message'] != null) {
        showNormalAlert(context, e.response?.data['message']);
      } else if (e.response?.data['error']['message'] != null) {
        showNormalAlert(context, e.response?.data['error']['message']);
      } else {
        showNormalAlert(context, e.message);
      }
    } catch (e) {
      showNormalAlert(context, e.toString());
    }
  }

  static Future get(url, body, context) async {
    try {
      final response = await dio.post(Constants.apiUrl + url, data: body);




      return response.data;
    } on DioError catch (e) {
      print(e);
      print(e.response);
      if (e.response?.data['message'] != null) {
        showNormalAlert(context, e.response?.data['message']);
      } else if (e.response?.data['error']['message'] != null) {
        showNormalAlert(context, e.response?.data['error']['message']);
      } else {
        showNormalAlert(context, e.message);
      }
    } catch (e) {
      showNormalAlert(context, e.toString());
    }
  }
}
