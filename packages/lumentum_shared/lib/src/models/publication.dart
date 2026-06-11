import 'author_brief.dart';

typedef ContentType =
    String; // book, article, poem, news, novel, encyclopedia

class PublicationListItem {
  const PublicationListItem({
    required this.id,
    required this.title,
    this.summary,
    required this.contentType,
    this.coverUrl,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.likedByMe,
    required this.author,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String? summary;
  final String contentType;
  final String? coverUrl;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final bool likedByMe;
  final AuthorBrief author;
  final String createdAt;

  factory PublicationListItem.fromJson(Map<String, dynamic> json) {
    return PublicationListItem(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String?,
      contentType: json['content_type'] as String,
      coverUrl: json['cover_url'] as String?,
      likeCount: json['like_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      viewCount: json['view_count'] as int? ?? 0,
      likedByMe: json['liked_by_me'] as bool? ?? false,
      author: AuthorBrief.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
    );
  }
}

class PublicationDetail {
  const PublicationDetail({
    required this.id,
    required this.title,
    this.summary,
    required this.body,
    required this.contentType,
    this.coverUrl,
    required this.status,
    required this.tags,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.likedByMe,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String? summary;
  final String body;
  final String contentType;
  final String? coverUrl;
  final String status;
  final List<String> tags;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final bool likedByMe;
  final AuthorBrief author;
  final String createdAt;
  final String updatedAt;

  factory PublicationDetail.fromJson(Map<String, dynamic> json) {
    return PublicationDetail(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String?,
      body: json['body'] as String,
      contentType: json['content_type'] as String,
      coverUrl: json['cover_url'] as String?,
      status: json['status'] as String,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      likeCount: json['like_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      viewCount: json['view_count'] as int? ?? 0,
      likedByMe: json['liked_by_me'] as bool? ?? false,
      author: AuthorBrief.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class PublicationFeed {
  const PublicationFeed({required this.items, required this.total});

  final List<PublicationListItem> items;
  final int total;

  factory PublicationFeed.fromJson(Map<String, dynamic> json) {
    return PublicationFeed(
      items: (json['items'] as List<dynamic>)
          .map((e) => PublicationListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
    );
  }
}

class PublicationComment {
  const PublicationComment({
    required this.id,
    required this.body,
    required this.author,
    required this.createdAt,
  });

  final String id;
  final String body;
  final AuthorBrief author;
  final String createdAt;

  factory PublicationComment.fromJson(Map<String, dynamic> json) {
    return PublicationComment(
      id: json['id'] as String,
      body: json['body'] as String,
      author: AuthorBrief.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
    );
  }
}

class LikeResult {
  const LikeResult({required this.liked, required this.likeCount});

  final bool liked;
  final int likeCount;

  factory LikeResult.fromJson(Map<String, dynamic> json) {
    return LikeResult(
      liked: json['liked'] as bool,
      likeCount: json['like_count'] as int,
    );
  }
}
