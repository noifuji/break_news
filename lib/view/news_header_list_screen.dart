import 'package:break_news/model/news_header.dart';
import 'package:break_news/view/news_header_widget.dart';
import 'package:break_news/viewmodel/news_header_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart' as constants;
import '../viewmodel/news_body_viewmodel.dart';
import 'news_body_screen.dart';

class RequiredCardListScreen extends StatefulWidget {
  RequiredCardListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RequiredCardListScreenState();
}

class _RequiredCardListScreenState extends State<RequiredCardListScreen> {
  late Future<void> latestHeaders;

  @override
  void initState() {
    super.initState();
    latestHeaders = Provider.of<NewsHeaderViewModel>(context, listen: false).getLatestHeaders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: latestHeaders,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (dataSnapshot.error != null) {
            if (kDebugMode) {
              print(dataSnapshot.error);
            }
            return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                Text('エラー。再ロードしてね。',
                    style: TextStyle(
                      fontFamily: constants.appFont,
                    ))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                TextButton(
                  child: const Text('RELOAD'),
                  onPressed: () {
                    setState(() {
                      latestHeaders = Provider.of<NewsHeaderViewModel>(context, listen: false)
                          .getLatestHeaders();
                    });
                  },
                )
              ]),
            ]);
          } else {
            List<NewsHeader> newsHeaders = Provider.of<NewsHeaderViewModel>(context).headers;

            List<NewsHeaderWidget> newsHeaderWidgets =
                newsHeaders.map((e) => NewsHeaderWidget(newsHeader: e)).toList();
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Provider.of<NewsHeaderViewModel>(context, listen: false)
                          .getLatestHeaders();
                    },
                    child: Column(children: <Widget>[
                      Expanded(
                          child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollEndNotification) {
                            if (scrollNotification.metrics.maxScrollExtent ==
                                scrollNotification.metrics.extentBefore) {
                              Provider.of<NewsHeaderViewModel>(context, listen: false)
                                  .getHeadersBefore();
                            }
                          }

                          return false;
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: newsHeaderWidgets.length,
                          itemBuilder: (BuildContext context, int index) => GestureDetector(
                              child: newsHeaderWidgets[index],
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                Provider.of<NewsHeaderViewModel>(context, listen: false)
                                    .selectHeader(newsHeaders[index]);
                                var page = await buildPageAsync();
                                Navigator.of(context).push(_createRoute(
                                    context,
                                    page,
                                    Provider.of<NewsHeaderViewModel>(context, listen: false),
                                    Provider.of<NewsBodyViewModel>(context, listen: false)));
                              }),
                        ),
                        //]),
                        //)
                      ))
                    ]),
                  ),
                ),
              ],
            );
          }
        });
  }

  Future<Widget> buildPageAsync() async {
    return Future.microtask(() {
      return NewsBodyScreen();
    });
  }

  Route _createRoute(
      BuildContext context, Widget page, NewsHeaderViewModel hvm, NewsBodyViewModel bvm) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: hvm),
          ChangeNotifierProvider.value(value: bvm),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(hvm.selectedHeader!.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontFamily: constants.appFont, fontSize: 14)),
              Text(hvm.selectedHeader!.siteTitle,
                  style: const TextStyle(fontFamily: constants.appFont, fontSize: 10)),
            ]),
          ),
          body: page,
        ),
      ),
/*      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },*/
    );
  }
}
