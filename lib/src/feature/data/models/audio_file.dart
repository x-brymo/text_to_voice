// models/audio_file.dart
class AudioFile {
  final String id;
  final String path;
  final String? name;
  final Duration duration;
  final DateTime createdAt;

  AudioFile({
    required this.id,
    required this.path,
    this.name,
    required this.duration,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'duration': duration.inMilliseconds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AudioFile.fromJson(Map<String, dynamic> json) {
    return AudioFile(
      id: json['id'],
      path: json['path'],
      name: json['name'],
      duration: Duration(milliseconds: json['duration']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}