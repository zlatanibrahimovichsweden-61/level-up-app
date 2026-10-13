import 'package:flutter/foundation.dart';

import 'student_profile.dart';

/// The `PATCH /me` request body — contract `openapi.yaml:601-624`.
///
/// The endpoint accepts exactly five things, all optional:
/// `name · email · avatarId · leaderboardVisible · scoreHidden`, under the rule
/// *"All fields optional; absent = unchanged."*
///
/// ## Why this body is hand-written instead of `@JsonSerializable`
///
/// Because of `email`, and only `email`. The contract declares it
/// `type: [string, "null"]` with the description *"null clears it"*, which
/// makes it the ONE field in this entire app with **three** wire states rather
/// than two:
///
/// | what the student did              | what must reach the wire |
/// |-----------------------------------|--------------------------|
/// | never touched the field           | the key is absent        |
/// | typed an address                  | `"email": "a@b.com"`     |
/// | emptied a field that had one      | `"email": null`          |
///
/// `String?` cannot carry that. Worse, the repo's standing convention actively
/// destroys it: every optional field on the registration bodies is annotated
/// `@JsonKey(includeIfNull: false)`, and `school_registration.dart:17-23`
/// documents why — there, some optional fields are FORBIDDEN rather than merely
/// absent, and sending `"cityName": null` earns a `validation_failed`.
///
/// **Applying that habit here would make clearing an email silently
/// impossible.** `includeIfNull: false` drops the key, the server reads the
/// absence as "unchanged", and the address the student just deleted survives.
/// Nothing throws. No banner appears. The student is simply not obeyed, and a
/// test that only asserts "the right value is sent" passes throughout.
///
/// So `email` gets an explicit three-valued representation — [EmailPatch] — and
/// this class serializes itself. That is the same call `ProfileCity` makes and
/// for the same class of reason: a generated serializer cannot express the
/// shape, so writing it by hand is the honest option rather than the lazy one.
///
/// The other four fields genuinely have only two states and follow the house
/// rule (null ⇒ untouched ⇒ omitted): `name` is non-nullable in the contract,
/// `avatarId` is a UUID with no "remove" meaning defined (removing a custom
/// avatar is `PUT /me/avatar` territory, and that is draft), and the two
/// privacy flags are booleans.
@immutable
class ProfileUpdate {
  const ProfileUpdate({
    this.name,
    this.email = const EmailPatch.unchanged(),
    this.avatarId,
    this.leaderboardVisible,
    this.scoreHidden,
  });

  /// Diffs the Edit Profile form against the profile it was seeded from, so
  /// only what the student actually changed reaches the wire.
  ///
  /// [name] and [email] are the raw field contents (trimmed here, once).
  /// [avatarId] is whatever the avatar picker selected, or null if it was never
  /// opened — an id equal to the one already on the account is not a change.
  factory ProfileUpdate.diff({
    required StudentProfile current,
    required String name,
    required String email,
    String? avatarId,
  }) {
    final trimmedName = name.trim();
    return ProfileUpdate(
      name: trimmedName == current.name ? null : trimmedName,
      email: _emailPatch(email.trim(), current.email),
      avatarId: (avatarId == null || avatarId == current.avatar.id)
          ? null
          : avatarId,
    );
  }

  /// The three-state decision, in one place so it can be read as a rule.
  ///
  /// An empty box means "clear it" ONLY when there was something to clear —
  /// otherwise the student who never had an email would send `"email": null`
  /// on every save, which is a write where nothing changed.
  static EmailPatch _emailPatch(String typed, String? current) {
    if (typed.isEmpty) {
      return (current == null || current.isEmpty)
          ? const EmailPatch.unchanged()
          : const EmailPatch.cleared();
    }
    return typed == current
        ? const EmailPatch.unchanged()
        : EmailPatch.set(typed);
  }

  /// Null ⇒ unchanged ⇒ omitted. `maxLength: 100` per the contract.
  final String? name;

  /// Three-valued — see the class doc. Defaults to "leave it alone".
  final EmailPatch email;

  /// A `/reference/avatars` id. Null ⇒ unchanged ⇒ omitted.
  final String? avatarId;

  /// adr-023 privacy toggles. Not collected by Edit Profile; Settings (Step 3)
  /// is their screen, and it reuses this body rather than inventing a second.
  final bool? leaderboardVisible;
  final bool? scoreHidden;

  /// The literal request body.
  ///
  /// The `email` arm is the point of this whole class: `EmailCleared` emits the
  /// key WITH an explicit null. Do not "tidy" it into an `if (email != null)`
  /// and do not put this object behind a serializer that strips nulls.
  Map<String, dynamic> toJson() => <String, dynamic>{
    if (name != null) 'name': name,
    ...switch (email) {
      EmailUnchanged() => const <String, dynamic>{},
      EmailSet(:final value) => <String, dynamic>{'email': value},
      EmailCleared() => <String, dynamic>{'email': null},
    },
    if (avatarId != null) 'avatarId': avatarId,
    if (leaderboardVisible != null) 'leaderboardVisible': leaderboardVisible,
    if (scoreHidden != null) 'scoreHidden': scoreHidden,
  };

  /// Nothing changed, so there is no request worth making.
  ///
  /// Deliberately derived from [toJson] rather than from the fields: "did
  /// anything reach the wire" is the actual question, and asking it of the body
  /// itself means a future field cannot be added without this answer following.
  bool get isEmpty => toJson().isEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileUpdate &&
          other.name == name &&
          other.email == email &&
          other.avatarId == avatarId &&
          other.leaderboardVisible == leaderboardVisible &&
          other.scoreHidden == scoreHidden;

  @override
  int get hashCode =>
      Object.hash(name, email, avatarId, leaderboardVisible, scoreHidden);

  /// Redacted to WHICH fields the update carries, never their values: [name]
  /// and [email] are a student's own data, and [avatarId] picks their face.
  /// The keys are the contract's own field names, so the string still says what
  /// the update is without saying what the student typed.
  @override
  String toString() => 'ProfileUpdate(fields: ${toJson().keys.toList()})';
}

/// What the student did to the `email` field, as a closed set.
///
/// Sealed rather than a nullable string plus a `clearEmail` boolean, because
/// those two can express a fourth, meaningless combination (`email: 'a@b.com'`
/// AND `clearEmail: true`) and nothing would stop a caller constructing it.
/// With a union the impossible state does not compile, and [ProfileUpdate.toJson]
/// switches exhaustively — adding a fourth state would break the build rather
/// than silently fall through to "omit".
@immutable
sealed class EmailPatch {
  const EmailPatch();

  /// The student did not touch the field. The key must NOT reach the wire.
  const factory EmailPatch.unchanged() = EmailUnchanged;

  /// The student typed an address.
  const factory EmailPatch.set(String value) = EmailSet;

  /// The student emptied a field that HELD an address. Sends `"email": null`,
  /// which is the contract's own spelling of "clear it".
  const factory EmailPatch.cleared() = EmailCleared;
}

final class EmailUnchanged extends EmailPatch {
  const EmailUnchanged();

  @override
  bool operator ==(Object other) => other is EmailUnchanged;

  @override
  int get hashCode => (EmailUnchanged).hashCode;

  @override
  String toString() => 'EmailPatch.unchanged()';
}

final class EmailSet extends EmailPatch {
  const EmailSet(this.value);

  final String value;

  @override
  bool operator ==(Object other) => other is EmailSet && other.value == value;

  @override
  int get hashCode => Object.hash(EmailSet, value);

  /// Redacted: [value] is the address the student typed.
  @override
  String toString() => 'EmailPatch.set(<redacted>)';
}

final class EmailCleared extends EmailPatch {
  const EmailCleared();

  @override
  bool operator ==(Object other) => other is EmailCleared;

  @override
  int get hashCode => (EmailCleared).hashCode;

  @override
  String toString() => 'EmailPatch.cleared()';
}
