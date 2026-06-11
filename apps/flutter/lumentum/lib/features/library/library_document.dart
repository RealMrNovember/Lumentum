class LibraryDocument {
  const LibraryDocument({
    required this.id,
    required this.title,
    required this.source,
    required this.text,
    required this.addedAt,
    this.isDemo = false,
  });

  final String id;
  final String title;
  final String source;
  final String text;
  final DateTime addedAt;
  final bool isDemo;

  int get wordCount => text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'source': source,
        'text': text,
        'added_at': addedAt.toIso8601String(),
        'is_demo': isDemo,
      };

  factory LibraryDocument.fromJson(Map<String, dynamic> json) {
    return LibraryDocument(
      id: json['id'] as String,
      title: json['title'] as String,
      source: json['source'] as String,
      text: json['text'] as String,
      addedAt: DateTime.parse(json['added_at'] as String),
      isDemo: json['is_demo'] as bool? ?? false,
    );
  }
}
