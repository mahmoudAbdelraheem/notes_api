import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

// ignore: prefer_interpolation_to_compose_strings
String _basicAuth = 'Basic ' + base64Encode(utf8.encode('memo:mahmoud'));

Map<String, String> myHeaders = {
  'authorization': _basicAuth,
};

//(CRUD) stand for Create - Read - Update - Delete
class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url), headers: myHeaders);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("Error => ${response.statusCode}");
      }
    } catch (e) {
      print("Error in catch => $e");
    }
  }

  postRequest(String url, Map data) async {
    //await Future.delayed(const Duration(seconds: 2));
    try {
      var response =
          await http.post(Uri.parse(url), body: data, headers: myHeaders);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("Error => ${response.statusCode}");
      }
    } catch (e) {
      print("Error in catch of Post request => $e");
    }
  }

  postRequestWithImage(String url, Map data, File file) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      var length = await file.length();
      var stream = http.ByteStream(file.openRead());
      var multiPartFile = http.MultipartFile('file', stream, length,
          filename: basename(file.path));
      request.headers.addAll(myHeaders);
      request.files.add(multiPartFile);

      data.forEach((key, value) {
        request.fields[key] = value;
      });

      var myRequest = await request.send();

      var response = await http.Response.fromStream(myRequest);
      if (myRequest.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('error in uploaded image... ${myRequest.statusCode}');
        print('error in uploaded image... ${response.body}');
      }
    } catch (e) {
      print("Error in catch of image upload => $e");
    }
  }
}
