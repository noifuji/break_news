import 'package:break_news/model/news_header.dart';

abstract class NewsHeaderApi {
  Future<List<NewsHeader>> fetch(int limit, DateTime datetime, bool newer);
}