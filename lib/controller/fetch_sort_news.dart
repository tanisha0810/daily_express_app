import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/api_key.dart';
import 'package:news_app/model/news_model.dart';

class SortNews {
  List<NewsArticle> sortNewsArticleList = [];

  Future<bool> getSortNews(int page) async {
    String newsFetchUrl =
        'https://newsapi.org/v2/everything?q=apple&from=2021-03-21&to=2021-03-21&sortBy=publishedAt&page=$page&apiKey=$apiKey';

    bool moreNews;

    var response = await http.get(newsFetchUrl);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == 'ok') {
      if (sortNewsArticleList.length != jsonResponse['totalResults']) {
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
            sortNewsArticleList.add(newsArticle);
          }
        });
        moreNews = true;
        print(sortNewsArticleList.length);
      } else {
        print(sortNewsArticleList.length);
        moreNews = false;
      }
    }
    return moreNews;
  }
}
