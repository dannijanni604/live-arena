class AppUser {
  String? id;
  String? name;
  String? username;
  String? email;
  String? about;
  String? avatar;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fcmToken;
  String? countryCode;
  String? countryName;
  String? type;
  List<String>? following;
  List<String>? followers;
  List<String>? sports;
  List<String>? languages;
  double? rating;
  int? hostedArena;
  int? joinedArena;

  AppUser(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.about,
      this.avatar,
      this.countryCode,
      this.countryName,
      this.createdAt,
      this.updatedAt,
      this.fcmToken,
      this.type,
      this.following,
      this.followers,
      this.rating,
      this.sports,
      this.hostedArena,
      this.joinedArena,
      this.languages});

  AppUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    about = json['about'];
    username = json['username'];
    email = json['email'];
    avatar = json['avatar'];
    countryCode = json['country_code'] ?? 'DE';
    countryName = json['country_name'] ?? 'Germany';
    createdAt = json['created_at']?.toDate();
    updatedAt = json['updated_at']?.toDate();
    fcmToken = json['fcm_token'];
    type = json['type'];
    following = json['following'] == null
        ? <String>[]
        : json['following'].cast<String>();
    followers = json['followers'] == null
        ? <String>[]
        : json['followers'].cast<String>();
    rating = json['rating'] as double;
    sports = json['sports'].cast<String>();
    languages = json['languages'].cast<String>();
    hostedArena = json['hosted_arena'] ?? 0;
    joinedArena = json['joined_arena'] ?? 0;
  }

  AppUser.fromRelationJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    avatar = json['avatar'] ?? "";
    rating = json['rating'] as double;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['about'] = about;
    data['username'] = username;
    data['email'] = email;
    data['avatar'] = avatar;
    data['country_code'] = countryCode;
    data['country_name'] = countryName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['fcm_token'] = fcmToken;
    data['type'] = type;
    data['following'] = following;
    data['followers'] = followers ?? [];
    data['sports'] = sports;
    data['languages'] = languages;
    data['rating'] = rating;
    data['hosted_arena'] = hostedArena ?? 0;
    data['joined_arena'] = joinedArena ?? 0;
    return data;
  }

  Map<String, dynamic> toRelationJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['avatar'] = avatar;
    data['rating'] = rating;
    return data;
  }
}
