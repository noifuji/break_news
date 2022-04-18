import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:break_news/exception/break_news_exception.dart';
import 'package:break_news/model/news_body.dart';
import 'package:http/http.dart' as http;

import '../../exception/exception_messages.dart';
import 'news_body_api.dart';
import '../../../assets/constants.dart' as constants;

class NewsBodyHttpApi implements NewsBodyApi {
  @override
  Future<NewsBody> fetch(Uri page) async {

    var response;

    try {
      response = await http.get(page,
          headers: {
            HttpHeaders.userAgentHeader:
            "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Mobile Safari/537.36",
          }).timeout(const Duration(seconds: constants.httpTimeoutInSeconds));
    } on TimeoutException catch(e) {
      throw BreakNewsException(ExceptionCode.networkTimeout);
    }

    if (response.statusCode == 200) {
      try {
        String stringHtml = utf8.decode(
            response.bodyBytes, allowMalformed: true);
        return NewsBody(pageUrl: page, body: stringHtml);
      } on FormatException catch(e) {
        throw BreakNewsException(ExceptionCode.failedToDecodeHtml);
      }
    } else {
      throw BreakNewsException(ExceptionCode.httpBadStatus);
    }
  }
}
