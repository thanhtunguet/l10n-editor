class FigmaFile {
  final String key;
  final String name;
  final String thumbnailUrl;
  final bool isDeleted;
  final bool isPublished;
  final bool isEditable;
  final bool canViewOnly;

  FigmaFile({
    required this.key,
    required this.name,
    required this.thumbnailUrl,
    required this.isDeleted,
    required this.isPublished,
    required this.isEditable,
    required this.canViewOnly,
  });

  factory FigmaFile.fromJson(Map<String, dynamic> json) {
    return FigmaFile(
      key: json['key'],
      name: json['name'],
      thumbnailUrl: json['thumbnailUrl'],
      isDeleted: json['isDeleted'],
      isPublished: json['isPublished'],
      isEditable: json['isEditable'],
      canViewOnly: json['canViewOnly'],
    );
  }
}
