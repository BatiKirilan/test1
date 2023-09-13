// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NewWordModel {
  final String name;
  final String description;
  NewWordModel({
    required this.name,
    required this.description,
  });

  NewWordModel copyWith({
    String? name,
    String? description,
  }) {
    return NewWordModel(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
    };
  }

  factory NewWordModel.fromMap(Map<String, dynamic> map) {
    return NewWordModel(
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewWordModel.fromJson(String source) =>
      NewWordModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NewWordModel(name: $name, description: $description)';

  @override
  bool operator ==(covariant NewWordModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.description == description;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode;
}
