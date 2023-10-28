class Message {
  String toId;
  String fromId;

  String read;

  Type type;

  String msg;
  String sent;
  Message({
    required this.toId,
    required this.fromId,
    required this.msg,
    required this.read,
    required this.sent,
    required this.type,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        toId: json['toId'],
        fromId: json['fromId'],
        msg: json['msg'],
        read: json['read'],
        sent: json['sent'],
        type: json['type'] == Type.image.name ? Type.image : Type.text);
  }
  Map<String, dynamic> toJson() => {
        'toId': toId,
        'fromId': fromId,
        'msg': msg,
        'read': read,
        'sent': sent,
        'type': type.name
      };
}

enum Type { text, image }
