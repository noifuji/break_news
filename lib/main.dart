import 'package:break_news/data/api/news_header_aws_api.dart';
import 'package:break_news/data/news_body_repository_impl.dart';
import 'package:break_news/view/news_header_list_screen.dart';
import 'package:break_news/viewmodel/news_body_viewmodel.dart';
import 'package:break_news/viewmodel/news_header_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/api/news_body_http_api.dart';
import 'data/news_header_repository_impl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Break News',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Break News'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
              value: NewsHeaderViewModel(
                  NewsHeaderRepositoryImpl(NewsHeaderAwsApi()))),
          ChangeNotifierProvider.value(
              value:
                  NewsBodyViewModel(NewsBodyRepositoryImpl(NewsBodyHttpApi()))),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: RequiredCardListScreen(),
        ));
  }
}
