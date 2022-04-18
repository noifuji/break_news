import 'package:break_news/domain/news_header_repository.dart';
import 'package:break_news/model/news_header.dart';
import 'package:flutter/cupertino.dart';

class NewsHeaderViewModel extends ChangeNotifier {
  final int _headerCount = 20;

  List<NewsHeader> _headers = [];
  NewsHeader? _selectedHeader;


  List<NewsHeader> get headers => _headers;
  NewsHeader? get selectedHeader => _selectedHeader;


  NewsHeaderRepository _newsHeaderRepository;

  NewsHeaderViewModel(this._newsHeaderRepository);

  Future<void> getLatestHeaders() async {
    _headers = await _newsHeaderRepository.getLatest(_headerCount);
    notifyListeners();
  }

  Future<void> getHeadersBefore(DateTime datetime) async {
    _headers.addAll(await _newsHeaderRepository.getBefore(_headerCount, datetime));
    notifyListeners();
  }

  void selectHeader(NewsHeader header) {
    _selectedHeader = header;
  }
}