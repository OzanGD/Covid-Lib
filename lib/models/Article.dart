import 'package:flutter/material.dart';

class Article {
  String author;
  String title;
  String description;
  String url;
  String urlToImage;

  Article({
    @required this.author,
    @required this.title,
    @required this.description,
    @required this.url,
    @required this.urlToImage,
  });

  factory Article.fromJson(Map<String, dynamic> parsedJson) {
    return Article(
      author: parsedJson['author'],
      title: parsedJson['title'],
      description: parsedJson['description'],
      url: parsedJson['url'],
      urlToImage: parsedJson['urlToImage'],
    );
  }
}
