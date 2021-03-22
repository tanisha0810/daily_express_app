//model class for storing news articles

class NewsArticle {
  String author;
  String title;
  String description;
  String content;
  String url;
  String urlToImage;
  String publishedAt;

  NewsArticle({
    this.author,
    this.title,
    this.description,
    this.content,
    this.url,
    this.urlToImage,
    this.publishedAt,
  });
}
