import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_constants.dart';


class GoogleApiService{


static  Future<List<String>> fetchSuggestions(String input)async{
    final response = await http.get(Uri.parse('${ApiConstants.googleBaseUrl}?input=$input&key=${ApiConstants.googleApiKey}'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final predictions = jsonData['predictions'] as List<dynamic>;

      var  _suggestions = predictions.map((prediction) => prediction['description'].toString()).toList();

      return _suggestions;
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

}