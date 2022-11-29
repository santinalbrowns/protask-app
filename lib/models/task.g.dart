// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String,
      name: json['name'] as String,
      due: DateTime.parse(json['due'] as String),
      completed: json['completed'] as bool,
      project: json['project'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'due': instance.due.toIso8601String(),
      'completed': instance.completed,
      'project': instance.project,
      'user': instance.user,
    };
