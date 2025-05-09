import 'package:NegXus/Config/Images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatBubble extends StatelessWidget {
  final String sms;
  final bool isComing;
  final String time;
  final String status;
  final String imageUrl;
  const ChatBubble({
    super.key,
    required this.sms,
    required this.isComing,
    required this.time,
    required this.status,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: isComing ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(
              minWidth: 10,
              maxWidth: MediaQuery.sizeOf(context).width / 1.3,
            ),
            decoration: isComing
                ? BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(10),
                    ),
                  )
                : BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
            child: imageUrl == ""
                ? Text(sms)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(imageUrl),
                      ),
                      SizedBox(height: 10),
                      Text(sms),
                    ],
                  ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: isComing ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              isComing
                  ? Text(time)
                  : Row(
                      children: [
                        Text(time),
                        SvgPicture.asset(
                          AssetsImage.chatStatusSVG,
                        ),
                      ],
                    )
            ],
          )
        ],
      ),
    );
  }
}
