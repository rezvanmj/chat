class Creator {
  Creator({
    String? username,
    bool? isGuest,
    String? email,
    bool? online,
    String? avatar,
    String? lastOnline,
  }) {
    _username = username;
    _isGuest = isGuest;
    _email = email;
    _online = online;
    _avatar = avatar;
    _lastOnline = lastOnline;
  }

  Creator.fromJson(dynamic json) {
    _username = json['username'];
    _isGuest = json['is_guest'];
    _email = json['email'];
    _online = json['online'];
    _avatar = json['avatar'];
    _lastOnline = json['lastOnline'];
  }
  String? _username;
  bool? _isGuest;
  String? _email;
  bool? _online;
  String? _avatar;
  String? _lastOnline;
  Creator copyWith({
    String? username,
    bool? isGuest,
    String? email,
    bool? online,
    String? avatar,
    String? lastOnline,
  }) =>
      Creator(
        username: username ?? _username,
        isGuest: isGuest ?? _isGuest,
        email: email ?? _email,
        online: online ?? _online,
        avatar: avatar ?? _avatar,
        lastOnline: lastOnline ?? _lastOnline,
      );
  String? get username => _username;
  bool? get isGuest => _isGuest;
  String? get email => _email;
  bool? get online => _online;
  String? get avatar => _avatar;
  String? get lastOnline => _lastOnline;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['is_guest'] = _isGuest;
    map['email'] = _email;
    map['online'] = _online;
    map['avatar'] = _avatar;
    map['lastOnline'] = _lastOnline;
    return map;
  }
}
