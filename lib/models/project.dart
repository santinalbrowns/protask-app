import 'package:json_annotation/json_annotation.dart';
import 'package:app/models/models.dart';

part 'project.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  final String id;
  final String name;
  final String description;
  final DateTime due;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double progress;
  final User user;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.due,
    required this.createdAt,
    required this.updatedAt,
    required this.progress,
    required this.user,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
