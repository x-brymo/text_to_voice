

// models/text_file.dart
class TextFile {
  final String id;
  final String path;
  final String? name;
  final String content;
  final DateTime createdAt;

  TextFile({
    required this.id,
    required this.path,
    this.name,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TextFile.fromJson(Map<String, dynamic> json) {
    return TextFile(
      id: json['id'],
      path: json['path'],
      name: json['name'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
