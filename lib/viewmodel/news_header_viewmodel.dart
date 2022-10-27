import 'package:break_news/domain/news_header_repository.dart';
import 'package:break_news/model/news_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

class NewsHeaderViewModel extends ChangeNotifier {
  final int _headerCount = 20;
  final _lock = new Lock();

  List<NewsHeader> _headers = [];
  NewsHeader? _selectedHeader;

  List<NewsHeader> get headers => _headers;

  NewsHeader? get selectedHeader => _selectedHeader;

  NewsHeaderRepository _newsHeaderRepository;

  NewsHeaderViewModel(this._newsHeaderRepository);

  Future<void> getLatestHeaders() async {
    if (kDebugMode) {
      print("get latest headers");
    }
    await _lock.synchronized(() async {
      _headers = await _newsHeaderRepository.getLatest(_headerCount);
    });
    notifyListeners();
  }

  Future<void> getHeadersBefore() async {
    if (_headers.isEmpty) {
      return;
    }

    await _lock.synchronized(() async {
      List<NewsHeader> before = [];
      before = await _newsHeaderRepository.getBefore(_headerCount, _headers.last.publishDateTime);
      if (kDebugMode) {
        print(
            "[current first]date:${_headers.first.publishDateTime}, title:${_headers.first.title}");
        print("[current last ]date:${_headers.last.publishDateTime}, title:${_headers.last.title}");
      }
      _headers.addAll(before);
    });
    notifyListeners();
  }

  void selectHeader(NewsHeader header) {
    _selectedHeader = header;
  }
}
