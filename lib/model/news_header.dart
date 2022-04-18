class NewsHeader {
  DateTime publishDateTime;
  String title;
  String siteTitle;
  Uri site;
  String description;
  Uri? thumbnail;
  String? thumbnailHash;

  NewsHeader({
    required this.title,
    required this.site,
    required this.publishDateTime,
    required this.siteTitle,
    required this.description,
    this.thumbnail,
    this.thumbnailHash
  });


}