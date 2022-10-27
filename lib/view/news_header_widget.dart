import 'package:break_news/model/news_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../assets/constants.dart' as constants;

class NewsHeaderWidget extends StatefulWidget {
  final NewsHeader newsHeader;

  NewsHeaderWidget({
    Key? key,
    required this.newsHeader,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsHeaderWidgetState();
}

class _NewsHeaderWidgetState extends State<NewsHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.newsHeader.thumbnail != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: FadeInImage.assetNetwork(
                  fadeInDuration: const Duration(milliseconds: 10),
                  placeholder: "assets/img/default_thumbnail.png",
                  image: widget.newsHeader.thumbnail.toString(),
                  imageErrorBuilder: (context, url, error) =>
                      const Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: Text(
                        widget.newsHeader.title,
                        style: const TextStyle(
                            fontSize: 16.0, fontFamily: constants.appFont),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: Text(
                        widget.newsHeader.siteTitle +
                            " | " +
                            publishedBefore(widget.newsHeader.publishDateTime),
                        style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: constants.appFont,
                            color: Colors.white70),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                child: Text(
                  widget.newsHeader.title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 16.0, fontFamily: constants.appFont),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 5.0, horizontal: 5.0),
                child: Text(
                  widget.newsHeader.siteTitle +
                      " | " +
                      publishedBefore(widget.newsHeader.publishDateTime),
                  style: const TextStyle(
                      fontSize: 12.0,
                      fontFamily: constants.appFont,
                      color: Colors.white70),
                ),
              ),
            ]),
      );
    }
  }

  String publishedBefore(DateTime pub) {
    Duration duration = DateTime.now().difference(pub);

    if (duration.inDays > 0) {
      return "${duration.inDays}日前";
    } else if (duration.inHours > 0) {
      return "${duration.inHours}時間前";
    } else if (duration.inMinutes > 0) {
      return "${duration.inMinutes}分前";
    }

    return "${duration.inSeconds}秒前";
  }
}
