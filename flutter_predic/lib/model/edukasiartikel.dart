// model/edukasiartikel.dart

class EducationArticle {
  final String id;
  final String title;
  final String? summary;
  final String? content;
  final String? category;
  final String? imageUrl;
  final String? slug;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EducationArticle({
    required this.id,
    required this.title,
    this.summary,
    this.content,
    this.category,
    this.imageUrl,
    this.slug,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory EducationArticle.fromJson(Map<String, dynamic> json) {
    return EducationArticle(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      summary: json['summary'],
      content: json['content'],
      category: json['category'],
      imageUrl: json['image_url'] ?? json['imageUrl'],
      slug: json['slug'],
      publishedAt: json['published_at'] != null 
          ? DateTime.tryParse(json['published_at']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'category': category,
      'image_url': imageUrl,
      'slug': slug,
      'published_at': publishedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;
  final PaginationInfo? pagination;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    this.pagination,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'],
      pagination: json['pagination'] != null 
          ? PaginationInfo.fromJson(json['pagination']) 
          : null,
    );
  }
}

class PaginationInfo {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  PaginationInfo({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'from': from,
      'to': to,
    };
  }
}