import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:break_news/data/api/news_header_api.dart';
import 'package:break_news/model/news_header.dart';
import 'package:http/http.dart' as http;

import '../../exception/break_news_exception.dart';
import '../../exception/exception_messages.dart';
import '../../../assets/constants.dart' as constants;

class NewsHeaderAwsApi implements NewsHeaderApi {
  final newsHeaderAwsApiUrl =
      'https://nvl1ybvc0i.execute-api.ap-northeast-1.amazonaws.com/beta-1/rss-articles';
  final paramLimit = "limit";
  final paramTime = "time";
  final paramNewer = "newer";

  @override
  Future<List<NewsHeader>> fetch(
      int limit, DateTime datetime, bool newer) async {
    String urlWithQuery = "$newsHeaderAwsApiUrl?"
        "$paramLimit=${limit.toString()}&"
        "$paramTime=${datetime.millisecondsSinceEpoch}&"
        "$paramNewer=${newer.toString()}";

    var response;

    try {
      response = await http.get(Uri.parse(urlWithQuery), headers: {
        HttpHeaders.userAgentHeader:
        "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Mobile Safari/537.36",
      }).timeout(const Duration(seconds: constants.httpTimeoutInSeconds));
    } on TimeoutException catch(e) {
      throw BreakNewsException(ExceptionCode.networkTimeout);

    }
    //If the http request is successful the statusCode will be 200
    if (response.statusCode == 200) {
      try {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> jsonArray = data["items"];

        List<NewsHeader> results = jsonArray
            .map((e) =>
            NewsHeader(
              title: e["title"],
              siteTitle: e["sitetitle"],
              site: Uri.parse(e["url"]),
              description: e["description"],
              publishDateTime:
              DateTime.fromMillisecondsSinceEpoch(e["publicationDate"]),
              thumbnail: e["thumbnail"] == "" ? null : Uri.parse(
                  e["thumbnail"]),
              thumbnailHash: e["hash"],
            ))
            .toList();

        return Future.value(results);
      } on FormatException catch(e) {
        throw BreakNewsException(ExceptionCode.failedToDecodeHtml);
      }
    } else {
      throw BreakNewsException(ExceptionCode.httpBadStatus);
    }
  }
}
