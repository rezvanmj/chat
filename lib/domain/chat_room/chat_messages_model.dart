class ChatMessages {
  ChatMessages(
      {int? id,
      String? creationId,
      String? message,
      dynamic src,
      String? fromType,
      String? messageType,
      String? status,
      dynamic mediaWidth,
      dynamic mediaHeight,
      dynamic originalFileName,
      String? createdAt,
      String? updatedAt,
      int? roomId,
      int? from,
      bool? isSelf}) {
    _id = id;
    _creationId = creationId;
    _message = message;
    _src = src;
    _fromType = fromType;
    _messageType = messageType;
    _status = status;
    _mediaWidth = mediaWidth;
    _mediaHeight = mediaHeight;
    _originalFileName = originalFileName;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _roomId = roomId;
    _from = from;
    _isSelf = isSelf;
  }

  ChatMessages.fromJson(dynamic json) {
    _id = json['id'];
    _isSelf = json['isSelf'];
    _creationId = json['creation_id'];
    _message = json['message'];
    _src = json['src'];
    _fromType = json['fromType'];
    _messageType = json['messageType'];
    _status = json['status'];
    _mediaWidth = json['mediaWidth'];
    _mediaHeight = json['mediaHeight'];
    _originalFileName = json['originalFileName'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _roomId = json['roomId'];
    _from = json['from'];
  }
  int? _id;
  bool? _isSelf;
  String? _creationId;
  String? _message;
  dynamic _src;
  String? _fromType;
  String? _messageType;
  String? _status;
  dynamic _mediaWidth;
  dynamic _mediaHeight;
  dynamic _originalFileName;
  String? _createdAt;
  String? _updatedAt;
  int? _roomId;
  int? _from;
  ChatMessages copyWith({
    int? id,
    String? creationId,
    bool? isSelf,
    String? message,
    dynamic src,
    String? fromType,
    String? messageType,
    String? status,
    dynamic mediaWidth,
    dynamic mediaHeight,
    dynamic originalFileName,
    String? createdAt,
    String? updatedAt,
    int? roomId,
    int? from,
  }) =>
      ChatMessages(
        isSelf: isSelf ?? _isSelf,
        id: id ?? _id,
        creationId: creationId ?? _creationId,
        message: message ?? _message,
        src: src ?? _src,
        fromType: fromType ?? _fromType,
        messageType: messageType ?? _messageType,
        status: status ?? _status,
        mediaWidth: mediaWidth ?? _mediaWidth,
        mediaHeight: mediaHeight ?? _mediaHeight,
        originalFileName: originalFileName ?? _originalFileName,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        roomId: roomId ?? _roomId,
        from: from ?? _from,
      );
  int? get id => _id;
  bool? get isSelf => _isSelf;
  String? get creationId => _creationId;
  String? get message => _message;
  dynamic get src => _src;
  String? get fromType => _fromType;
  String? get messageType => _messageType;
  String? get status => _status;
  dynamic get mediaWidth => _mediaWidth;
  dynamic get mediaHeight => _mediaHeight;
  dynamic get originalFileName => _originalFileName;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get roomId => _roomId;
  int? get from => _from;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['creation_id'] = _creationId;
    map['message'] = _message;
    map['src'] = _src;
    map['fromType'] = _fromType;
    map['messageType'] = _messageType;
    map['status'] = _status;
    map['mediaWidth'] = _mediaWidth;
    map['mediaHeight'] = _mediaHeight;
    map['originalFileName'] = _originalFileName;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['roomId'] = _roomId;
    map['from'] = _from;
    return map;
  }
}
