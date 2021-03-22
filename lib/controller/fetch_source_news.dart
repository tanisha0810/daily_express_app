import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/api_key.dart';
import 'package:news_app/model/news_model.dart';

class FilterNews {
  List<NewsArticle> sourcehNewsArticleList = [];

  Future<bool> getSourceNews(int page, String sourceId) async {
    String newsFetchUrl =
        'https://newsapi.org/v2/everything?sources=$sourceId&page=$page&apiKey=$apiKey';

    bool moreSearchNews;

    var response = await http.get(newsFetchUrl);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == 'ok') {
      if (sourcehNewsArticleList.length != jsonResponse['totalResults']) {
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
        print(sourcehNewsArticleList.length);
      } else {
        moreSearchNews = true;
        print(sourcehNewsArticleList.length);
      }
    } else {
      throw Exception('Error');
    }
    return moreSearchNews;
  }
}
