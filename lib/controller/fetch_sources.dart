import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/api_key.dart';
import 'package:news_app/model/news_source_model.dart';

class NewsSource {
  //List to store sorces
  List<Sources> newsSource = [];

  //url to fetch response
  Future<List<Sources>> getNewsSource() async {
    String newsFetchUrl =
        'https://newsapi.org/v2/sources?country=in&apiKey=$apiKey';

    //response
    var response = await http.get(newsFetchUrl);
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == 'ok') {
      //storing each response

      jsonResponse['sources'].forEach((sourceElement) {
        if (sourceElement['name'] != null && sourceElement['id'] != null) {
          newsSource.add(Sources(
              id: sourceElement['id'], sourceName: sourceElement['name']));
        }
      });
    } else if (jsonResponse['status'] == 'error') {
      throw Exception('Error');
    }
    return newsSource;
  }
}
