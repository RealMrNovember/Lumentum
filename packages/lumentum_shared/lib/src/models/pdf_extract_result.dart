class PdfExtractResult {
  const PdfExtractResult({
    required this.title,
    required this.text,
    required this.pageCount,
  });

  final String title;
  final String text;
  final int pageCount;

  factory PdfExtractResult.fromJson(Map<String, dynamic> json) {
    return PdfExtractResult(
      title: json['title'] as String,
      text: json['text'] as String,
      pageCount: json['page_count'] as int,
    );
  }
}
