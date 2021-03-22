import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatelessWidget {
  final String newsHeading;
  final String newsImageUrl;
  final String newsDescription;
  final String newsDate;
  final String newsUrl;

  NewsCard(
      {this.newsHeading,
      this.newsImageUrl,
      this.newsDescription,
      this.newsDate,
      this.newsUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: ExpandablePanel(
              header: Column(
                children: [
                  Image.network(
                    newsImageUrl,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newsHeading,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 4),
                        Text(
                            DateFormat('MMMM d, yyyy')
                                .format(DateTime.parse(newsDate)),
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
              expanded: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      newsDescription,
                      style: TextStyle(color: Colors.black54),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8),
                    RaisedButton(
                      onPressed: () {
                        launchUrl(newsUrl);
                      },
                      child: Text('READ MORE',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                      color: Color(0xff0FB6A9),
                    ),
                  ],
                ),
              ),
              // ignore: deprecated_member_use
              hasIcon: false,
            ),
          ),
          SizedBox(height: 4)
        ],
      ),
    );
  }

  void launchUrl(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}
