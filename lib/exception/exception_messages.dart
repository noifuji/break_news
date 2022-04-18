import 'break_news_exception.dart';

enum ExceptionCode {
  networkTimeout,
  httpBadStatus,
  failedToDecodeHtml,

}

Map<ExceptionCode, String> messages = {
  ExceptionCode.networkTimeout : "ネットワークの応答がないよ。もっかいやってみて。",
  ExceptionCode.httpBadStatus : "データをちゃんと受け取れなかったよ。",
  ExceptionCode.failedToDecodeHtml : "ページの読み込みに失敗した。あきらめて。",
};