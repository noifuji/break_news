import 'package:emoji_regex/emoji_regex.dart';
import 'package:html/parser.dart';

class ApplyDarkThemeUseCase {
  String call(String html) {
    var doc = parse(html);
    var heads = doc.getElementsByTagName("head");
    if(heads.isNotEmpty) {
      var style = doc.createElement("style");
      style.innerHtml = '''
        html{
          filter: invert(1) hue-rotate(180deg);
        }
        img,video,iframe,span.breaknews-emoji{
        filter: invert(1) hue-rotate(180deg);
        }
        iframe{
        width:100%
        }
        ''';

      heads[0].append(style);
    }

    final rawHtml =doc.outerHtml;
    //filter emoji
    final regex = emojiRegexRGI();
    final matches = regex.allMatches(rawHtml);
    final replacedHtml = matches.map((e) => e.group(0)).toSet().toList().fold<String>(rawHtml, (acc, e) => acc.replaceAll(e!, "<span class='breaknews-emoji'>$e</span>"));


    return replacedHtml;
  }
}