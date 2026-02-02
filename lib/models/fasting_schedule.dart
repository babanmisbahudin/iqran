class FastingSchedule {
  final DateTime date;
  final String type;         // "senin-kamis", "ayyamul-bidh", "syawwal"
  final String description;
  bool isDone;               // User checklist

  FastingSchedule({
    required this.date,
    required this.type,
    required this.description,
    this.isDone = false,
  });

  factory FastingSchedule.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.now();
    if (json['date'] is String) {
      try {
        parsedDate = DateTime.parse(json['date']);
      } catch (_) {
        parsedDate = DateTime.now();
      }
    } else if (json['date'] is DateTime) {
      parsedDate = json['date'];
    }

    return FastingSchedule(
      date: parsedDate,
      type: json['type'] ?? json['jenis'] ?? '',
      description: json['description'] ?? json['keterangan'] ?? '',
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'type': type,
      'description': description,
      'isDone': isDone,
    };
  }

  String get dateString {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  String toString() => '$dateString - $description';
}
