import 'chat_messages_model.dart';
import 'creator_model.dart';

/// country_code : "IR"
/// id : 833
/// name : "Hillz Group:gust-9262d3d3-5629-4e2b-aa8b-36200b8813c4"
/// creator_ip : "5.119.46.115"
/// lastMessageDate : null
/// isLeadRequestAccepted : false
/// isLeadRequestSended : false
/// createdAt : "2022-08-23T06:25:42.000Z"
/// updatedAt : "2022-08-23T06:30:03.000Z"
/// frk_creator_id : 6430
/// frk_responsible_id : null
/// dealershipId : 1
/// creator : {"username":"gust-9262d3d3-5629-4e2b-aa8b-36200b8813c4","is_guest":true,"email":"gust(7ac5a2c1-1954-4512-ae28-a42d4ae39fea)@gmail.com","online":false,"avatar":"/hillz/gust-9262d3d3-5629-4e2b-aa8b-36200b8813c4.png","lastOnline":"2022-08-23T07:11:37.000Z"}
/// ChatMessages : [{"id":1793,"creation_id":"4694e3ee-6877-4d48-a4a6-b804ec9c24dd","message":"Customer rejected lead request","src":null,"fromType":"SYSTEM","messageType":"text","status":"received","mediaWidth":null,"mediaHeight":null,"originalFileName":null,"createdAt":"2022-08-23T06:30:03.000Z","updatedAt":"2022-08-23T06:30:03.000Z","roomId":833,"from":6430}]
/// unreadMessagesCount : 0

class ChatRoomModel {
  ChatRoomModel({
    String? countryCode,
    int? id,
    String? name,
    String? creatorIp,
    dynamic lastMessageDate,
    bool? isLeadRequestAccepted,
    bool? isLeadRequestSended,
    String? createdAt,
    String? updatedAt,
    int? frkCreatorId,
    dynamic frkResponsibleId,
    int? dealershipId,
    Creator? creator,
    List<ChatMessages>? chatMessages,
    int? unreadMessagesCount,
  }) {
    _countryCode = countryCode;
    _id = id;
    _name = name;
    _creatorIp = creatorIp;
    _lastMessageDate = lastMessageDate;
    _isLeadRequestAccepted = isLeadRequestAccepted;
    _isLeadRequestSended = isLeadRequestSended;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _frkCreatorId = frkCreatorId;
    _frkResponsibleId = frkResponsibleId;
    _dealershipId = dealershipId;
    _creator = creator;
    _chatMessages = chatMessages;
    _unreadMessagesCount = unreadMessagesCount;
  }

  ChatRoomModel.fromJson(dynamic json) {
    _countryCode = json['country_code'];
    _id = json['id'];
    _name = json['name'];
    _creatorIp = json['creator_ip'];
    _lastMessageDate = json['lastMessageDate'];
    _isLeadRequestAccepted = json['isLeadRequestAccepted'];
    _isLeadRequestSended = json['isLeadRequestSended'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _frkCreatorId = json['frk_creator_id'];
    _frkResponsibleId = json['frk_responsible_id'];
    _dealershipId = json['dealershipId'];
    _creator =
        json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    if (json['ChatMessages'] != null) {
      _chatMessages = [];
      json['ChatMessages'].forEach((v) {
        _chatMessages?.add(ChatMessages.fromJson(v));
      });
    }
    _unreadMessagesCount = json['unreadMessagesCount'];
  }
  String? _countryCode;
  int? _id;
  String? _name;
  String? _creatorIp;
  dynamic _lastMessageDate;
  bool? _isLeadRequestAccepted;
  bool? _isLeadRequestSended;
  String? _createdAt;
  String? _updatedAt;
  int? _frkCreatorId;
  dynamic _frkResponsibleId;
  int? _dealershipId;
  Creator? _creator;
  List<ChatMessages>? _chatMessages;
  int? _unreadMessagesCount;
  ChatRoomModel copyWith({
    String? countryCode,
    int? id,
    String? name,
    String? creatorIp,
    dynamic lastMessageDate,
    bool? isLeadRequestAccepted,
    bool? isLeadRequestSended,
    String? createdAt,
    String? updatedAt,
    int? frkCreatorId,
    dynamic frkResponsibleId,
    int? dealershipId,
    Creator? creator,
    List<ChatMessages>? chatMessages,
    int? unreadMessagesCount,
  }) =>
      ChatRoomModel(
        countryCode: countryCode ?? _countryCode,
        id: id ?? _id,
        name: name ?? _name,
        creatorIp: creatorIp ?? _creatorIp,
        lastMessageDate: lastMessageDate ?? _lastMessageDate,
        isLeadRequestAccepted: isLeadRequestAccepted ?? _isLeadRequestAccepted,
        isLeadRequestSended: isLeadRequestSended ?? _isLeadRequestSended,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        frkCreatorId: frkCreatorId ?? _frkCreatorId,
        frkResponsibleId: frkResponsibleId ?? _frkResponsibleId,
        dealershipId: dealershipId ?? _dealershipId,
        creator: creator ?? _creator,
        chatMessages: chatMessages ?? _chatMessages,
        unreadMessagesCount: unreadMessagesCount ?? _unreadMessagesCount,
      );
  String? get countryCode => _countryCode;
  int? get id => _id;
  String? get name => _name;
  String? get creatorIp => _creatorIp;
  dynamic get lastMessageDate => _lastMessageDate;
  bool? get isLeadRequestAccepted => _isLeadRequestAccepted;
  bool? get isLeadRequestSended => _isLeadRequestSended;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get frkCreatorId => _frkCreatorId;
  dynamic get frkResponsibleId => _frkResponsibleId;
  int? get dealershipId => _dealershipId;
  Creator? get creator => _creator;
  List<ChatMessages>? get chatMessages => _chatMessages;
  int? get unreadMessagesCount => _unreadMessagesCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country_code'] = _countryCode;
    map['id'] = _id;
    map['name'] = _name;
    map['creator_ip'] = _creatorIp;
    map['lastMessageDate'] = _lastMessageDate;
    map['isLeadRequestAccepted'] = _isLeadRequestAccepted;
    map['isLeadRequestSended'] = _isLeadRequestSended;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['frk_creator_id'] = _frkCreatorId;
    map['frk_responsible_id'] = _frkResponsibleId;
    map['dealershipId'] = _dealershipId;
    if (_creator != null) {
      map['creator'] = _creator?.toJson();
    }
    if (_chatMessages != null) {
      map['ChatMessages'] = _chatMessages?.map((v) => v.toJson()).toList();
    }
    map['unreadMessagesCount'] = _unreadMessagesCount;
    return map;
  }
}
