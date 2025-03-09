class Quote {
  final String text;
  final String author;
  final String? category;

  Quote({required this.text, required this.author, this.category});

  factory Quote.fromJson(dynamic json) {
    if (json is List && json.isNotEmpty) {
      json = json[0];
    }

    return Quote(
      text: json['content'] ?? '',
      author: json['author'] ?? 'Unknown',
      category: (json['tags'] != null && json['tags'].isNotEmpty) ? json['tags'][0] : null,
    );
  }

  @override
  String toString() {
    return 'Quote:\n  Text: $text\n  Author: $author\n  Category: ${category ?? 'None'}';
  }
}
