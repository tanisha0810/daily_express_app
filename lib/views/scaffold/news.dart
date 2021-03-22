import 'package:flutter/material.dart';
import 'package:news_app/controller/fetch_news.dart';
import 'package:news_app/controller/fetch_sort_news.dart';
import 'package:news_app/controller/fetch_source_news.dart';
import 'package:news_app/controller/fetch_sources.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/model/news_source_model.dart';
import 'package:news_app/views/scaffold/search_news.dart';
import 'package:news_app/views/widgets/news_card.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _loading = true;
  bool _moreNews;
  int page = 1;

  News newsArticles = News();
  SortNews sortNewsArticles = SortNews();
  NewsSource newsSource = NewsSource();
  FilterNews filterNews = FilterNews();

  List<NewsArticle> _newsArticles = List<NewsArticle>();
  List<Sources> _newsSource = List<Sources>();

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getNews();
    getSources();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page = page + 1;
        getNews();
      }
    });
  }

  getSources() async {
    _newsSource = await newsSource.getNewsSource();
  }

  getNews() async {
    _moreNews = await newsArticles.getNews(page);
    _newsArticles = newsArticles.newsArticleList;
    setState(() {
      _loading = false;
    });
  }

  getFilterNews(String sourceId) async {
    _moreNews = await filterNews.getSourceNews(page, sourceId);
    _newsArticles = filterNews.sourcehNewsArticleList;
    setState(() {
      _loading = false;
    });
  }

  getSortNews() async {
    _moreNews = await sortNewsArticles.getSortNews(page);
    _newsArticles = sortNewsArticles.sortNewsArticleList;
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('News Feeds', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  print('search');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchNewsView(),
                          fullscreenDialog: true));
                }),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 0),
                                child: Text(
                                  'Filter by Source',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ),
                              Expanded(child: Container()),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _loading = true;
                                    page = 1;
                                    _newsArticles.clear();
                                    print(_newsArticles.length);
                                    getNews();
                                  },
                                  child: Text(
                                    'CLEAR',
                                    style: TextStyle(
                                      color: Color(0xffb60f1d),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              )
                            ],
                          ),
                          Divider(height: 0),
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: _newsSource.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_newsSource[index].sourceName),
                                onTap: () {
                                  Navigator.pop(context);
                                  _loading = true;
                                  page = 1;
                                  _newsArticles.clear();
                                  print(_newsArticles.length);
                                  getFilterNews(_newsSource[index].id);
                                },
                              );
                            },
                            separatorBuilder: (context, index) =>
                                Divider(height: 0),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: _newsArticles.length + 1,
                itemBuilder: (context, index) {
                  if (index == _newsArticles.length) {
                    return _moreNews
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'You are up to date',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          );
                  } else {
                    return NewsCard(
                      newsHeading: _newsArticles[index].title != null
                          ? _newsArticles[index].title
                          : '',
                      newsImageUrl: _newsArticles[index].urlToImage != null
                          ? _newsArticles[index].urlToImage
                          : '',
                      newsDescription: _newsArticles[index].description != null
                          ? _newsArticles[index].description
                          : '',
                      newsDate: _newsArticles[index].publishedAt != null
                          ? _newsArticles[index].publishedAt
                          : '',
                      newsUrl: _newsArticles[index].url != null
                          ? _newsArticles[index].url
                          : '',
                    );
                  }
                },
              ),
      ),
    );
  }
}
