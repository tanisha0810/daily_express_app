import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/api_key.dart';
import 'package:news_app/model/news_model.dart';

class News {
  //List to store response fetched from API
  List<NewsArticle> newsArticleList = [];

  //url to fetch news
  Future<bool> getNews(int page) async {
    String newsFetchUrl =
        'https://newsapi.org/v2/top-headlines?country=in&page=$page&apiKey=$apiKey';

    //bool to check if there is more news to fetch which helps in pagination
    bool moreNews;

    //response
    var response = await http.get(newsFetchUrl);
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == 'ok') {
      //checking if we have fetched all responses

      if (newsArticleList.length != jsonResponse['totalResults']) {
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

            newsArticleList.add(newsArticle);
          }
        });
        moreNews = true;
      } else {
        moreNews = false;
      }
    } else if (jsonResponse['status'] == 'error') {
      throw Exception('Error');
    }
    return moreNews;
  }
}
