import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsView extends StatelessWidget {
  final String newsAuthor;
  final String newsHeading;
  final String newsDate;
  final String newsUrl;
  final String newsContent;
  final String newsImageUrl;
  final String newsDescription;

  NewsView(
      {this.newsAuthor,
      this.newsHeading,
      this.newsDate,
      this.newsUrl,
      this.newsContent,
      this.newsDescription,
      this.newsImageUrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xffb60f1d)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  newsHeading,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  newsDescription,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Image.network(
                  newsImageUrl,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(height: 16),
                Text('Written By: $newsAuthor'),
                Text(
                    DateFormat('MMMM d, yyyy').format(DateTime.parse(newsDate)),
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
                SizedBox(height: 12),
                Text(
                  newsContent,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'To read complete article',
                      style: TextStyle(fontSize: 16),
                    ),
                    FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        launchUrl(newsUrl);
                      },
                      child: Text('CLICK HERE',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void launchUrl(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}
