import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/api_key.dart';
import 'package:news_app/model/news_model.dart';

class FilterNews {
  //List to store response fetched from API
  List<NewsArticle> sourcehNewsArticleList = [];

  //url to fetch news according to source
  Future<bool> getSourceNews(int page, String sourceId) async {
    String newsFetchUrl =
        'https://newsapi.org/v2/everything?sources=$sourceId&page=$page&apiKey=$apiKey';

    //bool to check if there is more news to fetch which helps in pagination
    bool moreSearchNews;

    //response
    var response = await http.get(newsFetchUrl);
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == 'ok') {
      //checking if we have fetched all responses

      if (sourcehNewsArticleList.length != jsonResponse['totalResults']) {
        //storing each element fetched

        jsonResponse['articles'].forEach((articleElement) {
          if (articleElement['urlToImage'] != null &&
              articleElement['description'] != null &&
              articleElement['url'] != null) {
            NewsArticle newsArticle = NewsArticle(
                author: articleElement['author'],
                description: articleElement['description'],
                publishedAt: articleElement['publishedAt'],
                title: articleElement['title'],
                url: articleElement['url'],
                urlToImage: articleElement['urlToImage'],
                content: articleElement['content']);
            sourcehNewsArticleList.add(newsArticle);
          }
        });
        moreSearchNews = true;
      } else {
        moreSearchNews = true;
      }
    } else if (jsonResponse['status'] == 'error') {
      throw Exception('Error');
    }
    return moreSearchNews;
  }
}
