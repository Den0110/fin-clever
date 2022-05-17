import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser extends ChangeNotifier {
  AppUser(this.id, this.name, this.email, this.imageUrl, this.junkCategories,
      this.junkLimit);

  String id = "";
  String? name;
  String? email;
  String? imageUrl;
  String? junkCategories;
  double junkLimit;

  String getDisplayName() {
    if (name?.isNotEmpty == true) {
      return name ?? "";
    } else {
      return email ?? "";
    }
  }

  String getAvatarUrl() {
    if (imageUrl?.isNotEmpty == true) {
      return imageUrl ?? "";
    } else {
      var nameForAva = getDisplayName();
      if (nameForAva.contains(' ')) {
        nameForAva.replaceAll(' ', '+');
      } else {
        nameForAva += '+';
      }
      return "https://ui-avatars.com/api?name=$nameForAva&background=03314B&color=fff";
    }
  }

  static AppUser? fromFirebaseUser(User? user) {
    if (user == null) return null;
    return AppUser(user.uid, user.displayName ?? "", user.email ?? "",
        user.photoURL ?? "", "", 0);
  }

  AppUser copyWith(
      {String? id,
      String? name,
      String? email,
      String? imageUrl,
      String? junkCategories,
      double? junkLimit}) {
    return AppUser(
      id ?? this.id,
      name ?? this.name,
      email ?? this.email,
      imageUrl ?? this.imageUrl,
      junkCategories ?? this.junkCategories,
      junkLimit ?? this.junkLimit,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
