// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: json['id'] as String,
      name: json['name'] as String,
      prefix: json['prefix'] as String,
      message: json['message'] as String,
      image: json['image'] as String,
      time: json['time'] as String,
      status: json['status'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'prefix': instance.prefix,
      'message': instance.message,
      'image': instance.image,
      'time': instance.time,
      'status': instance.status,
      'messages': instance.messages,
    };
