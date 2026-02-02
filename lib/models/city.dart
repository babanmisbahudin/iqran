class City {
  final String id;        // "semarang"
  final String name;      // "Semarang"
  final String province;  // "Jawa Tengah"

  City({
    required this.id,
    required this.name,
    required this.province,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] ?? json['lokasi'] ?? '',
      name: json['nama'] ?? json['name'] ?? '',
      province: json['provinsi'] ?? json['province'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': name,
      'provinsi': province,
    };
  }

  @override
  String toString() => '$name, $province';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          province == other.province;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ province.hashCode;
}
