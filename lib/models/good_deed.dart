class GoodDeed {
  final String id;
  final String title;
  final String category; // 'puasa', 'infaq', 'tilawah', 'dzikir', 'custom'
  final int expPoints;
  final DateTime date;
  final bool isCompleted;
  final bool isCustom;
  final String? description;

  GoodDeed({
    required this.id,
    required this.title,
    required this.category,
    required this.expPoints,
    required this.date,
    required this.isCompleted,
    required this.isCustom,
    this.description,
  });

  factory GoodDeed.fromJson(Map<String, dynamic> json) {
    return GoodDeed(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'custom',
      expPoints: json['expPoints'] ?? 0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      isCompleted: json['isCompleted'] ?? false,
      isCustom: json['isCustom'] ?? false,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'expPoints': expPoints,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'isCustom': isCustom,
      'description': description,
    };
  }

  GoodDeed copyWith({
    String? id,
    String? title,
    String? category,
    int? expPoints,
    DateTime? date,
    bool? isCompleted,
    bool? isCustom,
    String? description,
  }) {
    return GoodDeed(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      expPoints: expPoints ?? this.expPoints,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      isCustom: isCustom ?? this.isCustom,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => title;
}
