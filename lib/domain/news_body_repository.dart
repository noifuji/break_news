import 'package:break_news/model/news_body.dart';

abstract class NewsBodyRepository {
  Future<NewsBody> getByUrl(String url);
}