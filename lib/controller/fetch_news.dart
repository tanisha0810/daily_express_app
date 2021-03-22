import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/api_key.dart';
import 'package:news_app/model/news_model.dart';

class News {
  List<NewsArticle> newsArticleList = [];

  Future<bool> getNews(int page) async {
    String newsFetchUrl =
        'https://newsapi.org/v2/top-headlines?country=in&page=$page&apiKey=$apiKey';

    bool moreNews;
    var response = await http.get(newsFetchUrl);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == 'ok') {
      if (newsArticleList.length != jsonResponse['totalResults']) {
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
            );
            newsArticleList.add(newsArticle);
          }
        });
        moreNews = true;
        print(newsArticleList.length);
      } else {
        print(newsArticleList.length);
        moreNews = false;
      }
    }
    return moreNews;
  }
}
