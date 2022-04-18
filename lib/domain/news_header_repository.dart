

import '../model/news_header.dart';

abstract class NewsHeaderRepository {
  Future<List<NewsHeader>> getLatest(int count);
  Future<List<NewsHeader>> getBefore(int count, DateTime datetime);
}