class UserInfo {
  String? email;
  String? nickname;
  String? token;
  int? expiry;
  String? avatarPath;

  UserInfo(
      {this.email, this.expiry, this.nickname, this.token, this.avatarPath});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
        email: json['email'],
        nickname: json['nickname'],
        token: json['token'],
        expiry: json['expiry'],
        avatarPath: json['avatar']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["email"] = email;
    data["nickname"] = nickname;
    data["token"] = token;
    data["expiry"] = expiry;
    data["avatar"] = avatarPath;

    return data;
  }
}
