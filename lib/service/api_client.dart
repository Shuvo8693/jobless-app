// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/request/request.dart';
// import 'package:http/http.dart' as http;
// import '../Utils/app_constants.dart';
// import '../helpers/prefs_helpers.dart';
// import '../models/error_response.dart';
// import 'api_constants.dart';
//
//
//
//
// class ApiClient extends GetxService {
//   static var client = http.Client();
//
//   static const String noInternetMessage = "Can't connect to the internet!";
//   static const int timeoutInSeconds = 30;
//
//   static String bearerToken = "";
//
//   static Future<Response> getData(String uri,
//       {Map<String, dynamic>? query, Map<String, String>? headers}) async {
//     bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//
//     var mainHeaders = {
//       'Content-Type': 'application/x-www-form-urlencoded',
//       'Authorization': 'Bearer $bearerToken'
//     };
//     try {
//       debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
//
//       http.Response response = await client
//           .get(
//         Uri.parse(ApiConstant.baseUrl + uri),
//         headers: headers ?? mainHeaders,
//       )
//           .timeout(const Duration(seconds: timeoutInSeconds));
//       return handleResponse(response, uri);
//     } catch (e) {
//       debugPrint('------------${e.toString()}');
//       return const Response(statusCode: 1, statusText: noInternetMessage);
//     }
//   }
//
//
//
//   static Future<Response> postData(String uri, dynamic body,
//       { Map<String, String>? headers}) async {
//        bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//      var mainHeaders = {
//       // 'Content-Type': 'application/x-www-form-urlencoded',
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $bearerToken'
//     };
//     try {
//       debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
//       debugPrint('====> API Body: $body');
//
//       http.Response response = await client
//           .post(
//         Uri.parse(ApiConstant.baseUrl + uri),
//         body: body,
//         headers: headers ?? mainHeaders,
//       )
//           .timeout(const Duration(seconds: timeoutInSeconds));
//       debugPrint(
//           "==========> Response Post Method :------ : ${response.statusCode}");
//       return handleResponse(response, uri);
//     } catch (e) {
//       return const Response(statusCode: 1, statusText: noInternetMessage);
//     }
//   }
//
//
//
//   static Future<Response> patchData(String uri,
//       {dynamic body, Map<String, String>? headers}) async {
//     bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//
//     var mainHeaders = {
//       'Content-Type': 'application/x-www-form-urlencoded',
//       'Authorization': 'Bearer $bearerToken'
//     };
//     try {
//       debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
//       http.Response response = await client
//           .patch(
//         Uri.parse(ApiConstant.baseUrl + uri),
//         body: body,
//         headers: headers ?? mainHeaders,
//       )
//           .timeout(const Duration(seconds: timeoutInSeconds));
//       return handleResponse(response, uri);
//     } catch (e) {
//       debugPrint('------------${e.toString()}');
//       return const Response(statusCode: 1, statusText: noInternetMessage);
//     }
//   }
//
//
//
//
//   static Future<Response> postMultipartData(
//       String uri, Map<String, String> body,
//       {required List<MultipartBody> multipartBody,
//         Map<String, String>? headers}) async {
//     try {
//       bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//
//       var mainHeaders = {
//         'Content-Type': 'application/x-www-form-urlencoded',
//         'Authorization': 'Bearer $bearerToken'
//       };
//
//       debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
//       debugPrint('====> API Body: $body with ${multipartBody.length} picture');
//       var request =
//       http.MultipartRequest('POST', Uri.parse(ApiConstant.baseUrl + uri));
//       request.headers.addAll(headers ?? mainHeaders);
//       for (MultipartBody element in multipartBody) {
//
//         request.files.add(await http.MultipartFile.fromPath(element.key, element.file.path,));
//
//       }
//       request.fields.addAll(body);
//       http.Response _response =
//       await http.Response.fromStream(await request.send());
//       return handleResponse(_response, uri);
//     } catch (e) {
//       return const Response(statusCode: 1, statusText: noInternetMessage);
//     }
//   }
//
//   static Future<Response> patchMultipartData(
//       String uri, dynamic body,
//       {required List<MultipartBody> multipartBody,
//         Map<String, String>? headers}) async {
//     try {
//       bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//
//       var mainHeaders = {
//         'Content-Type': 'application/x-www-form-urlencoded',
//         'Authorization': 'Bearer $bearerToken'
//       };
//
//       debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
//       debugPrint('====> API Body: $body with ${multipartBody.length} picture');
//       var request =
//       http.MultipartRequest('PATCH', Uri.parse(ApiConstant.baseUrl + uri));
//       request.headers.addAll(headers ?? mainHeaders);
//       for (MultipartBody element in multipartBody) {
//
//         request.files.add(await http.MultipartFile.fromPath(element.key, element.file.path,));
//
//       }
//       request.fields.addAll(body);
//       http.Response _response =
//       await http.Response.fromStream(await request.send());
//       return handleResponse(_response, uri);
//     } catch (e) {
//       return const Response(statusCode: 1, statusText: noInternetMessage);
//     }
//   }
//
//
//   Future<Response> putData(String uri, dynamic body,
//       {Map<String, String>? headers}) async {
//     bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//
//     var mainHeaders = {
//       'Content-Type': 'application/x-www-form-urlencoded',
//       'Authorization': 'Bearer $bearerToken'
//     };
//
//     try {
//       debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
//       debugPrint('====> API Body: $body');
//
//       http.Response response = await http
//           .put(
//         Uri.parse(ApiConstant.baseUrl + uri),
//         body: jsonEncode(body),
//         headers: headers ?? mainHeaders,
//       )
//           .timeout(const Duration(seconds: timeoutInSeconds));
//       return handleResponse(response, uri);
//     } catch (e) {
//       return const Response(statusCode: 1, statusText: noInternetMessage);
//     }
//   }
//
//   static Future<Response> putMultipartData(String uri, Map<String, String> body,
//       {required List<MultipartBody> multipartBody, Map<String, String>? headers}) async {
//     try {
//       bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//
//       var mainHeaders = {
//         'Content-Type': 'application/x-www-form-urlencoded',
//         'Authorization': 'Bearer $bearerToken'
//       };
//       debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
//       debugPrint('====> API Body: $body with ${multipartBody.length} picture');
//       var request =
//       http.MultipartRequest('POST', Uri.parse(ApiConstant.baseUrl + uri));
//       request.headers.addAll(headers ?? mainHeaders);
//       for (MultipartBody element in multipartBody) {
//         for (MultipartBody element in multipartBody) {
//           request.files.add(await http.MultipartFile.fromPath(element.key, element.file.path,));
//         }
//       }
//
//       request.fields.addAll(body);
//
//       http.Response _response =
//       await http.Response.fromStream(await request.send());
//       return handleResponse(_response, uri);
//     } catch (e) {
//       return const Response(statusCode: 1, statusText: noInternetMessage);
//     }
//   }
//
//   static Future<Response> deleteData(String uri,
//       {Map<String, String>? headers, dynamic body}) async {
//     bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//
//     var mainHeaders = {
//       'Content-Type': 'application/x-www-form-urlencoded',
//       'Authorization': 'Bearer $bearerToken'
//     };
//     try {
//       debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
//       debugPrint('====> API Call: $uri\n Body: ${body}');
//
//       http.Response response = await http
//           .delete(Uri.parse(ApiConstant.baseUrl + uri),
//           headers: headers ?? mainHeaders, body: body)
//           .timeout(const Duration(seconds: timeoutInSeconds));
//       return handleResponse(response, uri);
//     } catch (e) {
//       return const Response(statusCode: 1, statusText: noInternetMessage);
//     }
//   }
//
//
//
//   static Response handleResponse(http.Response response, String uri) {
//     dynamic body;
//
//     try {
//       body = jsonDecode(response.body);
//     }
//     catch (e) {
//       debugPrint(e.toString());
//     }
//     Response response0 = Response(
//       body: body ?? response.body,
//       bodyString: response.body.toString(),
//       request: Request(
//           headers: response.request!.headers,
//           method: response.request!.method,
//           url: response.request!.url),
//       headers: response.headers,
//       statusCode: response.statusCode,
//       statusText: response.reasonPhrase,
//     );
//
//     if (response0.statusCode != 200 &&
//         response0.body != null &&
//         response0.body is! String) {
//       debugPrint("response ${response0.body.runtimeType}");
//       ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
//
//       debugPrint("${errorResponse.statusCode}");
//       response0 = Response(
//           statusCode: response0.statusCode,
//           body: response0.body,
//           statusText: errorResponse.message);
//
//       // if(_response.body.toString().startsWith('{errors: [{code:')) {
//       //   ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
//       //   _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: _errorResponse.errors[0].message);
//       // }else if(_response.body.toString().startsWith('{message')) {
//       //   _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: _response.body['message']);
//       // }
//       // response0 = Response(
//       //   statusCode: response0.statusCode,
//       //   body: response0.body,
//       // );
//     } else if (response0.statusCode != 200 && response0.body == null) {
//       response0 = const Response(statusCode: 0, statusText: noInternetMessage);
//     }
//
//     debugPrint(
//         '====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
//     // log.e("Handle Response error} ");
//     return response0;
//   }
// }
//
// class MultipartBody {
//   String key;
//   File file;
//   MultipartBody(this.key, this.file);
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import '../helpers/prefs_helpers.dart';
import '../models/error_response.dart';
import '../utils/app_constants.dart';
import 'api_constants.dart';

class ApiClient extends GetxService {
  static var client = http.Client();
  static const String noInternetMessage = "Can't connect to the internet!";
  static const int timeoutInSeconds = 30;
  static String bearerToken = "";

//==========================================> Get Data <======================================
  static Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');

      http.Response response = await client
          .get(
        Uri.parse(ApiConstants.baseUrl + uri),
        headers: headers ?? mainHeaders,
      )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('------------${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

//==========================================> Post Data <======================================
  static Future<Response> postData(String uri,
      { dynamic body,Map<String, String>? headers}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
    var mainHeaders = {
      // 'Content-Type': 'application/x-www-form-urlencoded',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await client.post(Uri.parse(ApiConstants.baseUrl + uri),
        body: body,
        headers: headers ?? mainHeaders,
      )
          .timeout(const Duration(seconds: timeoutInSeconds));
      debugPrint(
          "==========> Response Post Method :------ : ${response.statusCode}");
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

//==========================================> Patch Data <======================================
  static Future<Response> patchData(String uri, dynamic body,
      { Map<String, String>? headers}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
    var mainHeaders = {
      // 'Content-Type': 'application/x-www-form-urlencoded',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await client
          .patch(
        Uri.parse(ApiConstants.baseUrl + uri),
        body: body?? null,
        headers: headers ?? mainHeaders,
      )
          .timeout(const Duration(seconds: timeoutInSeconds));
      debugPrint(
          "==========> Response Post Method :------ : ${response.statusCode}");
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> Test Post Data <======================================
  static Future<Response> testPostData(String uri, var body,
      {Map<String, String>? headers}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await client
          .post(
        Uri.parse(ApiConstants.baseUrl + uri),
        body: body,
        headers: headers ?? mainHeaders,
      )
          .timeout(const Duration(seconds: timeoutInSeconds));
      debugPrint(
          "==========> Response Post Method :------ : ${response.statusCode}");
      return handleResponse(response, uri);
    } catch (e) {
      print("===> $e");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> Post Multipart Data <======================================
  static Future<Response> postMultipartData(
      String uri, Map<String, String> body,
      {List<MultipartBody>? multipartBody,
        List<MultipartListBody>? multipartListBody,
        Map<String, String>? headers}) async {
    try {
      bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
      var mainHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken'
      };
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body with ${multipartBody?.length} picture');

      var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.baseUrl + uri));
      request.fields.addAll(body);

      if (multipartBody!.isNotEmpty) {
        multipartBody.forEach((element) async {
          debugPrint("path : ${element.file.path}");

          if (element.file.path.contains(".mp4")) {
            debugPrint("media type mp4 ==== ${element.file.path}");
            request.files.add(http.MultipartFile(
              element.key,
              element.file.readAsBytes().asStream(),
              element.file.lengthSync(),
              filename: 'video.mp4',
              contentType: MediaType('video', 'mp4'),
            ));
          } else if (element.file.path.contains(".png")) {
            debugPrint("media type png ==== ${element.file.path}");
            request.files.add(http.MultipartFile(
              element.key,
              element.file.readAsBytes().asStream(),
              element.file.lengthSync(),
              filename: 'image.png',
              contentType: MediaType('image', 'png'),
            ));
          } else if (element.file.path.contains(".jpg")) {
            debugPrint("media type png ==== ${element.file.path}");
            request.files.add(http.MultipartFile(
              element.key,
              element.file.readAsBytes().asStream(),
              element.file.lengthSync(),
              filename: 'image.jpg',
              contentType: MediaType('image', 'jpg'),
            ));
          } else if (element.file.path.contains(".jpeg")) {
            debugPrint("media type jpeg ==== ${element.file.path}");
            request.files.add(http.MultipartFile(
              element.key,
              element.file.readAsBytes().asStream(),
              element.file.lengthSync(),
              filename: 'image.jpeg',
              contentType: MediaType('image', 'jpeg'),
            ));
          }
        });
      }

      request.headers.addAll(mainHeaders);
      http.StreamedResponse response = await request.send();
      final content = await response.stream.bytesToString();
      debugPrint(
          '====> API Response: [${response.statusCode}}] $uri\n$content');

      return Response(
          statusCode: response.statusCode,
          statusText: noInternetMessage,
          body: content);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }


//==========================================> Put Data <======================================
  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await http
          .put(
        Uri.parse(ApiConstants.baseUrl + uri),
        body: jsonEncode(body),
        headers: headers ?? mainHeaders,
      )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> Put Multipart Data <======================================
  static Future<Response> putMultipartData(String uri, Map<String, String> body,
      {List<MultipartBody>? multipartBody,
        List<MultipartListBody>? multipartListBody,
        Map<String, String>? headers}) async {
    try {
      bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

      var mainHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $bearerToken'
      };

      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body with ${multipartBody?.length} picture');

      var request =
      http.MultipartRequest('PUT', Uri.parse(ApiConstants.baseUrl + uri));
      request.fields.addAll(body);

      if (multipartBody!.isNotEmpty) {
        multipartBody.forEach((element) async {
          debugPrint("path : ${element.file.path}");
          String? mimeType = mime(element.file.path);
          request.files.add(http.MultipartFile(
            element.key,
            element.file.readAsBytes().asStream(),
            element.file.lengthSync(),
            contentType: MediaType.parse(mimeType!),
          ));
        });
      }
      request.headers.addAll(mainHeaders);
      http.StreamedResponse response = await request.send();
      final content = await response.stream.bytesToString();
      debugPrint(
          '====> API Response: [${response.statusCode}}] $uri\n$content');

      return Response(
          statusCode: response.statusCode,
          statusText: noInternetMessage,
          body: json.decode(content));
    } catch (e) {
      print("====================================e $e");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> Patch Multipart Data <======================================
  static Future<Response> patchMultipartData(
      String uri,
      Map<String, String> body,
      {List<MultipartBody>? multipartBody,
        List<MultipartListBody>? multipartListBody,
        Map<String, String>? headers}) async {
    try {
      bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
      // bearerToken = PrefsHelper.token;

      var mainHeaders = {
        'Authorization': 'Bearer $bearerToken'
      };

      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body with ${multipartBody?.length} picture');
      var request =
      http.MultipartRequest('PATCH', Uri.parse(ApiConstants.baseUrl + uri));
      request.fields.addAll(body);

      if (multipartBody!.isNotEmpty) {
        multipartBody.forEach((element) async {
          debugPrint("path : ${element.file.path}");
          String? mimeType = mime(element.file.path);
          request.files.add(http.MultipartFile(
            element.key,
            element.file.readAsBytes().asStream(),
            element.file.lengthSync(),
            filename: element.file.path.split('/').last,
            contentType: MediaType.parse(mimeType!),
          ));
        });
      }
      request.headers.addAll(mainHeaders);
      http.StreamedResponse response = await request.send();
      final content = await response.stream.bytesToString();
      debugPrint(
          '====> API Response: [${response.statusCode}}] $uri\n$content');

      return Response(
          statusCode: response.statusCode,
          statusText: noInternetMessage,
          body: json.decode(content));
    } catch (e) {
      print("====================================e $e");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> Delete Data <======================================
  static Future<Response> deleteData(String uri,
      {Map<String, String>? headers, dynamic body}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Call: $uri\n Body: ${body}');

      http.Response response = await http
          .delete(Uri.parse(ApiConstants.baseUrl + uri),
          headers: headers ?? mainHeaders, body: body)
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> Handle Response <======================================
  static Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
      response0 = Response(
          statusCode: response0.statusCode,
          body: response0.body,
          statusText: errorResponse.message);
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = const Response(statusCode: 0, statusText: noInternetMessage);
    }

    debugPrint(
        '====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    return response0;
  }
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

class MultipartListBody {
  String key;
  String value;
  MultipartListBody(this.key, this.value);
}