import 'package:break_news/data/api/news_header_api.dart';
import 'package:break_news/domain/news_header_repository.dart';
import 'package:break_news/model/news_header.dart';

class NewsHeaderRepositoryImpl implements NewsHeaderRepository {
  NewsHeaderApi _api;

  NewsHeaderRepositoryImpl(this._api);

  @override
  Future<List<NewsHeader>> getBefore(int count, DateTime datetime) {
    return _api.fetch(count, datetime, false);
  }

  @override
  Future<List<NewsHeader>> getLatest(int count) {
    return getBefore(count, DateTime.now());
  }
  
}