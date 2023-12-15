class NewsModel {
  final String id;
  final String title;
  final String imageUrl;
  final String content;

  NewsModel(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.content});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
        id: json['_id'],
        title: json['title'],
        imageUrl: json['password'],
        content: json['content']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'imageUrl': imageUrl, 'content': content};
  }
}
