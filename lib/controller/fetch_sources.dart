import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/api_key.dart';
import 'package:news_app/model/news_source_model.dart';

class NewsSource {
  List<Sources> newsSource = [];

  Future<List<Sources>> getNewsSource() async {
    String newsFetchUrl =
        'https://newsapi.org/v2/sources?country=in&apiKey=$apiKey';

    var response = await http.get(newsFetchUrl);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == 'ok') {
      jsonResponse['sources'].forEach((sourceElement) {
        if (sourceElement['name'] != null && sourceElement['id'] != null) {
          newsSource.add(Sources(
              id: sourceElement['id'], sourceName: sourceElement['name']));
        }
      });
    } else {
      throw Exception('Error');
    }
    return newsSource;
  }
}
