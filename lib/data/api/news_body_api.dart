import 'package:break_news/model/news_body.dart';

abstract class NewsBodyApi {
  Future<NewsBody> fetch(Uri page);
}