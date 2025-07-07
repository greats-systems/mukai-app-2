import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
  sqliteConfig: SqliteSerializable(),
)
class FinancialArticle extends OfflineFirstWithSupabaseModel {
  String? id;
  String? createdAt;
  String? profileId;
  String? title;
  String? contentType;
  String? body;
  String? excerpt;
  String? coverImage;
  bool? isFree;
  double? price;
  String? currency;
  String? readingTime;
  String? publishedAt;
  String? status;
  List<Map<String, dynamic>>? tags;
  int? views;
  int? likes;
  bool? commentsEnabled;

  FinancialArticle({
    this.id,
    this.createdAt,
    this.profileId,
    this.title,
    this.contentType,
    this.body,
    this.excerpt,
    this.coverImage,
    this.isFree,
    this.price,
    this.currency,
    this.readingTime,
    this.publishedAt,
    this.status,
    this.tags,
    this.views,
    this.likes,
    this.commentsEnabled,
  });

  // Factory method to create an Wallet from a JSON map
  factory FinancialArticle.fromJson(Map<String, dynamic> json) {
    return FinancialArticle(
      id: json['id'],
      createdAt: json['created_at'],
      profileId: json['profile_id'],
      title: json['title'],
      contentType: json['content_type'],
      body: json['body'],
      excerpt: json['excerpt'],
      coverImage: json['cover_image'],
      isFree: json['is_free'],
      price: json['price'],
      currency: json['currency'],
      readingTime: json['reading_time'],
      publishedAt: json['published_at'],
      status: json['status'],
      tags: List<Map<String, dynamic>>.from(json['tags'] ?? []),
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      commentsEnabled: json['comments_enabled'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'profile_id': profileId,
      'title': title,
      'content_type': contentType,
      'body': body,
      'excerpt': excerpt,
      'cover_image': coverImage,
      'is_free': isFree,
      'price': price,
      'currency': currency,
      'reading_time': readingTime,
      'published_at': publishedAt,
      'status': status,
      'tags': tags,
      'views': views,
      'likes': likes,
      'comments_enabled': commentsEnabled,
    };
  }
}
