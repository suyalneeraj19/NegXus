class ChatModel {
  String? id;
  String? message;
  String? senderName;
  String? senderId;
  String? receiverId;
  String? timestamp;
  String? readStatus;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? documentUrl;
  List<String>? reactions;
  List<dynamic>? replies;

  ChatModel(
      {this.id,
      this.message,
      this.senderName,
      this.senderId,
      this.receiverId,
      this.timestamp,
      this.readStatus,
      this.imageUrl,
      this.videoUrl,
      this.audioUrl,
      this.documentUrl,
      this.reactions,
      this.replies});

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    senderName = json['senderName'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    timestamp = json['timestamp'];
    readStatus = json['readStatus'];
    imageUrl = json['imageUrl'];
    videoUrl = json['videoUrl'];
    audioUrl = json['audioUrl'];
    documentUrl = json['documentUrl'];
    if (json['reactions'] is List) {
      reactions = json['reactions'] == null ? null : List<String>.from(json['reactions']);
    }
    if (json['replies'] is List) {
      replies = json["replies"] ?? [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['senderName'] = this.senderName;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['timestamp'] = this.timestamp;
    data['readStatus'] = this.readStatus;
    data['imageUrl'] = this.imageUrl;
    data['videoUrl'] = this.videoUrl;
    data['audioUrl'] = this.audioUrl;
    data['documentUrl'] = this.documentUrl;
    data['reactions'] = this.reactions;
    if (this.replies != null) {
      data['replies'] = replies;
    }
    return data;
  }
}
