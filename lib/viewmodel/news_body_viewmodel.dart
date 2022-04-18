import 'package:break_news/domain/apply_dark_theme_usecase.dart';
import 'package:break_news/domain/news_body_repository.dart';
import 'package:break_news/domain/remove_unnecessary_tags_usecase.dart';
import 'package:flutter/cupertino.dart';

import '../model/news_body.dart';

class NewsBodyViewModel extends ChangeNotifier {
  List<NewsBody> _bodies = [];
  NewsBodyRepository _newsBodyRepository;

  NewsBodyViewModel(this._newsBodyRepository);

  List<NewsBody> get bodies => _bodies;

  bool canGoBack() {
    return _bodies.isNotEmpty;
  }

  void goBack() {
    if (canGoBack()) {
      _bodies.removeAt(_bodies.length - 1);
    } else {
      throw Exception("You cannot go back.");
    }
  }

  Future<void> getBody(String url) async {
    NewsBody news = await _newsBodyRepository.getByUrl(url);

    final removeUnncessaryTags = RemoveUnnecessaryTagsUseCase();
    final applyDarkTheme = ApplyDarkThemeUseCase();

    String html = removeUnncessaryTags(news.body, url);
    html = applyDarkTheme(html);

    news.body = html;
    _bodies.add(news);
  }
}
