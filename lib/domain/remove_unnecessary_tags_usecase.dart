import 'package:html/parser.dart';

class RemoveUnnecessaryTagsUseCase {
  String call(String html, String url) {
    var doc = parse(html);
    doc.getElementsByTagName("aside").forEach((element) {
      element.remove();
    });
    doc.getElementsByTagName("nav").forEach((element) {
      element.remove();
    });
    doc.getElementsByTagName("header").forEach((element) {
      element.remove();
    });
    doc.getElementsByTagName("footer").forEach((element) {
      element.remove();
    });

    var filterTags = ["dl", "div", "section", "ul"];

    for (var tag in filterTags) {
      doc.getElementsByTagName(tag).forEach((element) {
        const divBlackList = [
          "ads",
          "rss",
          "comment",
          "ranking",
          "tag",
          "social",
          "home",
          "link",
          "relate",
          "banner",
          "smartphone",
          "suggest",
          "header",
          "menu_bar"
        ];
        bool hasNgClass = divBlackList.fold<bool>(false, (prev, e) {
          for (String className in element.classes) {
            if (className.contains(e)) {
              return true;
            }
          }
          return false || prev;
        });

        bool hasNgId = divBlackList.fold<bool>(false, (prev, e) {
          if (element.id.contains(e)) {
            return true;
          }
          return false || prev;
        });

        if (hasNgClass || hasNgId) {
          element.remove();
        }
      });
    }

    doc.getElementsByTagName("script").forEach((element) {
      const javascriptWhiteList = [
        "https://platform.twitter.com/widgets.js",
        "//platform.twitter.com/widgets.js"
      ];
      if (javascriptWhiteList.contains(element.attributes["src"])) {
        return;
      }
      element.remove();
    });

    //imgur有効化
    doc.getElementsByTagName("blockquote.imgur-embed-pub").forEach((element) {
      const javascriptWhiteList = [
        "https://platform.twitter.com/widgets.js",
        "//platform.twitter.com/widgets.js"
      ];
      if (javascriptWhiteList.contains(element.attributes["src"])) {
        return;
      }
      var imgurKey = element.attributes["data-id"];

      element.replaceWith(doc.createElement("""
      <iframe 
        allowfullscreen="true"
        mozallowfullscreen="true"
        webkitallowfullscreen="true"
        class="imgur-embed-iframe-pub imgur-embed-iframe-pub-$imgurKey-false-332"
        scrolling="no"
        src="http://imgur.com/$imgurKey/embed?context=false&amp;ref=${Uri.encodeComponent(url)}&amp;w=332"
        id="imgur-embed-iframe-pub-$imgurKey"
        style="height: 500px; width: 332px; margin: 10px 0px; padding: 0px;">
      </iframe>

"""));
    });

    return doc.outerHtml;
  }
}
