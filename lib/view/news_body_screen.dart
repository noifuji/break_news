import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../assets/constants.dart' as constants;
import '../model/news_body.dart';
import '../model/news_header.dart';
import '../viewmodel/news_body_viewmodel.dart';
import '../viewmodel/news_header_viewmodel.dart';

class NewsBodyScreen extends StatefulWidget {
  NewsBodyScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsBodyScreenState();
}

class _NewsBodyScreenState extends State<NewsBodyScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

  }

  @override
  Widget build(BuildContext context) {
    NewsHeader? selected =
        Provider.of<NewsHeaderViewModel>(context).selectedHeader;

    if (kDebugMode) {
      print("start building NewsBodyScreen${DateTime.now().millisecondsSinceEpoch}");
    }

    return FutureBuilder(
        future: Provider.of<NewsBodyViewModel>(context, listen: false)
            .getBody(selected!.site.toString()),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            if (kDebugMode) {
              print("start building progress      ${DateTime.now().millisecondsSinceEpoch}");
            }
            return const Center(child: Text("LOADING...",style:  TextStyle(
                fontFamily: constants.appFont, fontSize: 14)));
          } else if (dataSnapshot.error != null) {
            return const Text('エラー。再ロードしてね。',
                style: TextStyle(
                  fontFamily: constants.appFont,
                ));
          } else {
            NewsBody news = Provider.of<NewsBodyViewModel>(context).bodies.last;
            if (kDebugMode) {
              print("start building WebView       ${DateTime.now().millisecondsSinceEpoch}");
            }
            return WillPopScope(
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true,
                  backgroundColor: Theme.of(context).canvasColor,
                  onWebViewCreated:
                      (WebViewController webViewController) async {
                    _controller = webViewController;
                    webViewController.loadUrl(Uri.dataFromString(news.body,
                            mimeType: 'text/html',
                            encoding: Encoding.getByName('utf-8'))
                        .toString());
                  },
                  navigationDelegate: (NavigationRequest request) async {

                    if(request.url.startsWith(selected.site.toString())) {
                      await Provider.of<NewsBodyViewModel>(context, listen: false).getBody(request.url);
                      _controller.loadUrl(Uri.dataFromString(Provider.of<NewsBodyViewModel>(context, listen: false).bodies.last.body,
                          mimeType: 'text/html',
                          encoding: Encoding.getByName('utf-8'))
                          .toString());
                    } else {
                      if (await canLaunch(request.url)) {
                        await launch(request.url);
                      } else {
                        throw Exception('Could not launch ${request.url}');//TODO
                      }
                    }
                    return NavigationDecision.prevent;
                  },
                ),
                onWillPop: _exitApp);
          }
        });

    /*return WillPopScope(
        child: WebView(
          onWebViewCreated: (WebViewController webViewController) async {
            _controller = webViewController;
            var response = await http.get(
                selected!.site,
                headers: {
                  HttpHeaders.userAgentHeader:
                      "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Mobile Safari/537.36",
                });
            //If the http request is successful the statusCode will be 200
            if (response.statusCode == 200) {
              String stringHtml =
                  utf8.decode(response.bodyBytes, allowMalformed: true);

              var doc = parse(stringHtml);
              doc.getElementsByTagName("aside").forEach((element) {
                element.remove();
              });
              doc.getElementsByTagName("nav").forEach((element) {
                element.remove();
              });
              //doc.getElementsByTagName("section").forEach((element) {element.remove();});
              doc.getElementsByTagName("header").forEach((element) {
                element.remove();
              });
              doc.getElementsByTagName("footer").forEach((element) {
                element.remove();
              });
              doc.getElementsByTagName("script").forEach((element) {
                if (element.attributes["src"] ==
                    "https://platform.twitter.com/widgets.js") {
                  return;
                }
                element.remove();
              });

              webViewController.loadUrl(Uri.dataFromString(doc.outerHtml,
                      mimeType: 'text/html',
                      encoding: Encoding.getByName('utf-8'))
                  .toString());
            } else {
              print(response.statusCode);
            }
          },
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) async {
            //他のリンクへ飛ぶ場合はここに処理を書く
            if (request.url.startsWith(
                'http://blog.livedoor.jp/kinisoku/archives/5333282.html')) {
              return NavigationDecision.navigate;
            }

            if (await canLaunch(request.url)) {
              await launch(request.url);
            } else {
              throw 'Could not launch $request.url';
            }
            return NavigationDecision.prevent;
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        ),
        onWillPop: _exitApp);*/
  }

  Future<bool> _exitApp() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
