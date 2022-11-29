import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:app/models/models.dart';

class MessageView extends StatelessWidget {
  final Message message;

  const MessageView({Key? key, required this.message}) : super(key: key);

  date(String date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final sentDate = DateTime.parse(date);
    final yess = DateTime(sentDate.year, sentDate.month, sentDate.day);

    final check = now.difference(yess).inHours;

    if (yess == today) {
      return Jiffy(date).jm;
    }

    if (check > 24 && check <= 48) {
      return Jiffy(date).fromNow();
    }

    if (check > 48 && check <= 168) {
      return Jiffy(date).EEEE;
    }

    if (check > 168) {
      // show 7/8/2022
      return Jiffy(date).MMMEd;
    }

    if (check > 8760) {
      return Jiffy(date).yMd;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: message.isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              //width: 340,
              constraints: const BoxConstraints(maxWidth: 340),
              decoration: BoxDecoration(
                color: message.isSender
                    ? Colors.lightBlue.withOpacity(1)
                    : Colors.lightBlue.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                  topRight: message.isSender
                      ? Radius.zero
                      : const Radius.circular(30),
                  topLeft: const Radius.circular(30),
                  bottomLeft: message.isSender
                      ? const Radius.circular(30)
                      : Radius.zero,
                  bottomRight: const Radius.circular(30),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isSender ? Colors.white : Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                date(message.time.toString()),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
