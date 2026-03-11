class PostModel {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final int views;
  final int userId;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.views,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json['id'] as int,
    title: json['title'] as String,
    body: json['body'] as String,
    tags: List<String>.from(json['tags'] as List),
    likes: (json['reactions'] as Map<String, dynamic>)['likes'] as int,
    dislikes: (json['reactions'] as Map<String, dynamic>)['dislikes'] as int,
    views: json['views'] as int,
    userId: json['userId'] as int,
  );
}
