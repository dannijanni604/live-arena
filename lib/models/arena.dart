import 'package:cloud_firestore/cloud_firestore.dart';

import 'app_user.dart';

class Arena {
  String? id;
  String? title;
  String? description;
  String? image;
  String? startAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? listners;
  List<String>? broadcasters;
  List<String>? broadcastersAvatar;
  List<String>? broadcastersLive;
  List<String>? searchTerms;
  List<DocumentReference<Map<String, dynamic>>>? broadcasterRef;
  AppUser? user;
  bool? live;
  String? sport;
  String? arean;
  List<String>? languages;

  Arena({
    this.id,
    this.title,
    this.description,
    this.image,
    this.startAt,
    this.createdAt,
    this.updatedAt,
    this.listners,
    this.broadcasters,
    this.broadcastersAvatar,
    this.broadcastersLive,
    this.user,
    this.live,
    this.sport,
    this.arean,
    this.languages,
    this.searchTerms,
    this.broadcasterRef,
  });

  Arena.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    id = json.id;
    title = json.data()!['title'];
    description = json.data()!['description'];
    image = json.data()!['image'];
    startAt = json.data()!['start_at'];
    // createdAt = json.data()!['created_at'].toDate();
    // updatedAt = json.data()!['updated_at'].toDate();
    listners = json.data()!['listeners'].cast<String>();
    broadcasters = json.data()!['broadcasters'].cast<String>();
    broadcastersAvatar = json.data()!['broadcasters_avatar'].cast<String>();
    broadcastersLive = json.data()!['broadcasters_live'].cast<String>();
    broadcasterRef = json.data()!['broadcaster_ref'] == null
        ? []
        : json['broadcaster_ref']
            .cast<DocumentReference<Map<String, dynamic>>>();
    user = json.data()!['user'] != null
        ? AppUser.fromRelationJson(json['user'])
        : null;
    live = json.data()!['live'];
    sport = json.data()!['sport'];
    arean = json.data()!['arean'];
    languages = json.data()!['languages'].cast<String>();
    searchTerms = json.data()!['search_terms'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['start_at'] = startAt;
    data['created_at'] = createdAt ?? FieldValue.serverTimestamp();
    data['updated_at'] = updatedAt ?? FieldValue.serverTimestamp();
    data['listeners'] = listners ?? [];
    data['broadcasters'] = broadcasters ?? [];
    data['broadcasters_avatar'] = broadcastersAvatar ?? [];
    data['broadcasters_live'] = broadcastersLive ?? [];
    data['broadcaster_ref'] = broadcasterRef ?? [];
    if (user != null) {
      data['user'] = user!.toRelationJson();
    }
    data['live'] = live ?? false;
    data['sport'] = sport;
    data['arean'] = arean;
    data['languages'] = languages;
    data['search_terms'] = searchTerms;
    return data;
  }
}
