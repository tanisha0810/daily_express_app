import 'package:flutter/material.dart';
import 'package:news_app/controller/fetch_news.dart';
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

  //bool for pagination
  bool _moreNews;

  //page to fetch news according to pages
  int page = 1;

  //initializing objects
  News newsArticles = News();
  NewsSource newsSource = NewsSource();
  FilterNews filterNews = FilterNews();

  //Lists to store news articles and sources
  List<NewsArticle> _newsArticles = List<NewsArticle>();
  List<Sources> _newsSource = List<Sources>();

  //scroll controller for pagination
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //function to fetch news
    getNews();

    //function to fetch sources
    getSources();
    super.initState();
    //scroll listener

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page = page + 1;
        getNews();
      }
    });
  }

  //function for source fetching
  getSources() async {
    _newsSource = await newsSource.getNewsSource();
  }

  //function to fetch news
  getNews() async {
    _moreNews = await newsArticles.getNews(page);
    _newsArticles = newsArticles.newsArticleList;
    setState(() {
      _loading = false;
    });
  }

  //function to fetch news according to filter of sources which by default are sorted according to RECENT FIRST
  getFilterNews(String sourceId) async {
    _moreNews = await filterNews.getSourceNews(page, sourceId);
    _newsArticles = filterNews.sourcehNewsArticleList;
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
                        fullscreenDialog: true),
                  );
                }),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          topLeft: Radius.circular(16),
                        ),
                      ),
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
                                  'Filter by News Source',
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
                                    //Reseting values and lists to store news
                                    _loading = true;
                                    page = 1;
                                    _newsArticles.clear();
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
                                  //Reseting values and lists to store new news according to filter
                                  _loading = true;
                                  page = 1;
                                  _newsArticles.clear();
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
                  //Pagination- to fetch more news
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
                    //widget to represent news card
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
                      newsContent: _newsArticles[index].content != null
                          ? _newsArticles[index].content
                          : '',
                      newsAuthor: _newsArticles[index].author != null
                          ? _newsArticles[index].author
                          : '',
                    );
                  }
                },
              ),
      ),
    );
  }
}
