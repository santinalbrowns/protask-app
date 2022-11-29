// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String,
      text: json['text'] as String,
      from: json['from'] as String,
      isSender: json['isSender'] as bool,
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'from': instance.from,
      'isSender': instance.isSender,
      'time': instance.time.toIso8601String(),
    };
