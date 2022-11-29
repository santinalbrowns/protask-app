import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String id;
  final String text;
  final String from;
  final bool isSender;
  final DateTime time;

  const Message({
    required this.id,
    required this.text,
    required this.from,
    required this.isSender,
    required this.time,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
