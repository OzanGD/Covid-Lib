import 'package:flutter/material.dart';
import 'package:covid_lib/models/Article.dart';

class Articles {
  List<Article> articles;

  Articles({
    @required this.articles,
  });

  factory Articles.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['articles'] as List;
    List<Article> articlesList = list.map((i) => Article.fromJson(i)).toList();

    return Articles(
      articles: articlesList,
    );
  }
}
