class AnOtherUserProfileResponse {
  String id = "";
  String phone = "";
  String password = "";
  String? gender = "";
  String fullName = "";
  String? avatarPath = "";
  String? bio = "";
  List<String>? friend;
  String? updatedAt = "";
  String? backgroundPath = "";
  AnOtherUserProfileResponse(this.id, this.phone, this.password, this.gender,
      this.fullName, this.avatarPath, this.bio, this.friend, this.updatedAt,this.backgroundPath);
  AnOtherUserProfileResponse.buildDefault();
  factory AnOtherUserProfileResponse.fromJson(Map<String, dynamic> json) {
    List<String> friendResponse = [];
    if (json['friends'] != null) {
      List<dynamic> arrData = json['friends'];
      for (var i = 0; i < arrData.length; i++) {
        String friend = arrData[i];
        friendResponse.add(friend);
      }
    }
    return AnOtherUserProfileResponse(
      json['_id'],
      json['phone'],
      json['password'],
      json['gender'],
      json['full_name'],
      json['avatar_path'],
      json['bio'],
      friendResponse,
      json['updatedAt'],
      json['background_path'],
    );
  }
}