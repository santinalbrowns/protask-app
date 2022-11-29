import 'package:json_annotation/json_annotation.dart';
import 'package:app/models/message.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  const Chat({
    required this.id,
    required this.name,
    required this.prefix,
    required this.message,
    required this.image,
    required this.time,
    required this.status,
    required this.messages,
  });

  final String id;
  final String name;
  final String prefix;
  final String message;
  final String image;
  final String time;
  final String status;
  final List<Message> messages;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
