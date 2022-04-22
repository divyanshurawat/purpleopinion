class User {
  final int id, favorite, reqID, photoID;
  final String senderID,
      senderName,
      SenderPhoto,
      PhotoLink,
      time,
      question,
      comment;

  const User(
      {required this.id,
      required this.senderName,
      required this.senderID,
      required this.time,
      required this.question,
      required this.comment,
      required this.favorite,
      required this.photoID,
      required this.PhotoLink,
      required this.reqID,
      required this.SenderPhoto});

  Map<String, dynamic> toMap() {
    return {
      'SenderName': senderName,
      'SenderId': senderID,
      'SenderPhoto': SenderPhoto,
      'uniqueId': id,
      'timeofentry': time,
      'question': question,
      'comment': comment,
      'favorite': favorite,
      'PhotoId': photoID,
      'PhotoRequestId': reqID,
      'PhotoLink': PhotoLink,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : senderName = map['SenderName'],
        id = map['uniqueId'],
        senderID = map['SenderId'],
        SenderPhoto = map['SenderPhoto'],
        photoID = map['PhotoId'],
        favorite =map['favorite'],
  comment=map['comment'],
  time =map['timeofentry'],
  question =map['question'],
        reqID = map['PhotoRequestId'],
        PhotoLink = map['PhotoLink'];
}
