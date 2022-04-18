import 'package:break_news/data/api/news_body_api.dart';
import 'package:break_news/domain/news_header_repository.dart';
import 'package:break_news/model/news_body.dart';
import 'package:break_news/model/news_header.dart';

import '../domain/news_body_repository.dart';

class NewsBodyRepositoryImpl implements NewsBodyRepository {
  NewsBodyApi _api;

  NewsBodyRepositoryImpl(this._api);

  @override
  Future<NewsBody> getByUrl(String url) {
    return _api.fetch(Uri.parse(url));
  }
  
}