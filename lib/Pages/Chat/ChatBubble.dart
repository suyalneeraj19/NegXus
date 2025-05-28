import 'package:NegXus/Config/Images.dart';
import 'package:NegXus/Pages/Chat/VoiceMessagePlayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isComming;
  final String time;
  final String status;
  final String imageUrl;
  final String profileImage;
  final String audioUrl;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isComming,
    required this.time,
    required this.status,
    required this.imageUrl,
    required this.profileImage,
    this.audioUrl = "",
  });

  @override
  Widget build(BuildContext context) {
    final Gradient incomingGradient = LinearGradient(
      colors: [Colors.purple.shade100, Colors.purple.shade50],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final Gradient outgoingGradient = LinearGradient(
      colors: [Colors.blue.shade100, Colors.blue.shade50],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isComming ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isComming)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(profileImage),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isComming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width / 1.3,
                  ),
                  decoration: BoxDecoration(
                    gradient: isComming ? incomingGradient : outgoingGradient,
                    borderRadius: isComming
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(18),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(0),
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: (isComming ? Colors.purple : Colors.blue).withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: audioUrl.isNotEmpty
                      ? VoiceMessagePlayer(audioUrl: audioUrl, isComming: isComming)
                      : imageUrl == ""
                          ? Text(
                              message,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                message == "" ? Container() : const SizedBox(height: 10),
                                message == ""
                                    ? Container()
                                    : Text(
                                        message,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ],
                            ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: isComming ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (!isComming) ...[
                      const SizedBox(width: 10),
                      SvgPicture.asset(
                        AssetsImage.statusSVG,
                        color: status == "read" ? Colors.green : Colors.grey,
                        width: 18,
                      )
                    ]
                  ],
                )
              ],
            ),
          ),
          if (!isComming)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(profileImage),
              ),
            ),
        ],
      ),
    );
  }
}
