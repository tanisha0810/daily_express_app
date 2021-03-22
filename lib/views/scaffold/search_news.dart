import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/controller/fetch_search_news.dart';
import 'package:news_app/model/news_model.dart';

class SearchNewsView extends StatefulWidget {
  @override
  _SearchNewsViewState createState() => _SearchNewsViewState();
}

class _SearchNewsViewState extends State<SearchNewsView> {
  int page = 1;
  bool _loading = true;
  bool _moreSearchNews;
  String _searchQuery;
  SearchNews searchNews = SearchNews();
  List<NewsArticle> _searchNewsArticles = List<NewsArticle>();
  ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('scroll');
        page = page + 1;
        getMoreNews();
      }
    });
  }

  processSearchQuery() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      print(_searchQuery);
      _loading = true;
      _searchNewsArticles.clear();
      getNews();
    }
  }

  getNews() async {
    _moreSearchNews = await searchNews.getSearchNews(_searchQuery, page);
    _searchNewsArticles = searchNews.searchNewsArticleList;
    setState(() {
      _loading = false;
    });
  }

  getMoreNews() async {
    _moreSearchNews = await searchNews.getSearchNews(_searchQuery, page);
    _searchNewsArticles = searchNews.searchNewsArticleList;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Search', style: TextStyle(color: Colors.white)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _key,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Type here..',
                    prefixIcon: Icon(Icons.search, color: Colors.black54),
                    filled: true,
                    fillColor: Color(0x20868486),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                  ),
                  validator: (strValue) {
                    if (strValue.isEmpty) {
                      return 'Enter valid keyword';
                    }
                    return null;
                  },
                  onSaved: (strValue) {
                    _searchQuery = strValue;
                  },
                  onFieldSubmitted: (strValue) {
                    processSearchQuery();
                  },
                ),
              ),
            ),
            Expanded(
              child: _searchQuery == null
                  ? Center(child: Container(child: Text('Nothing to show')))
                  : _loading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: _searchNewsArticles.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _searchNewsArticles.length) {
                              return _moreSearchNews
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          'You are up to date',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                    );
                            } else {
                              return ListTile(
                                title: Text(_searchNewsArticles[index].title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    DateFormat('MMMM d, yyyy').format(
                                        DateTime.parse(
                                            _searchNewsArticles[index]
                                                .publishedAt)),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54)),
                              );
                            }
                          },
                          separatorBuilder: (context, index) => Divider(),
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  padding: EdgeInsets.all(16.0),
                  color: Color(0xffb60f1d),
                  onPressed: () {
                    processSearchQuery();
                  },
                  child: Text('SEARCH', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
