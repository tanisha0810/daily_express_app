import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/api_key.dart';
import 'package:news_app/model/news_model.dart';

class SearchNews {
  List<NewsArticle> searchNewsArticleList = [];

  Future<bool> getSearchNews(String query, int page) async {
    String newsFetchUrl =
        'https://newsapi.org/v2/everything?qInTitle=$query&page=$page&apiKey=$apiKey';

    bool moreSearchNews;

    var response = await http.get(newsFetchUrl);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == 'ok') {
      if (searchNewsArticleList.length != jsonResponse['totalResults']) {
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
            searchNewsArticleList.add(newsArticle);
          }
        });
        moreSearchNews = true;
        print(searchNewsArticleList.length);
      } else {
        moreSearchNews = true;
        print(searchNewsArticleList.length);
      }
    }
    return moreSearchNews;
  }
}
