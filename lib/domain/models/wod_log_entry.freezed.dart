// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wod_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WodLogEntry {

 String get wodKey; DateTime get doneAt; DateTime get wodDate; Branch get branch; Program get program; String? get score; String? get note;
/// Create a copy of WodLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WodLogEntryCopyWith<WodLogEntry> get copyWith => _$WodLogEntryCopyWithImpl<WodLogEntry>(this as WodLogEntry, _$identity);

  /// Serializes this WodLogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WodLogEntry&&(identical(other.wodKey, wodKey) || other.wodKey == wodKey)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt)&&(identical(other.wodDate, wodDate) || other.wodDate == wodDate)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.program, program) || other.program == program)&&(identical(other.score, score) || other.score == score)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wodKey,doneAt,wodDate,branch,program,score,note);

@override
String toString() {
  return 'WodLogEntry(wodKey: $wodKey, doneAt: $doneAt, wodDate: $wodDate, branch: $branch, program: $program, score: $score, note: $note)';
}


}

/// @nodoc
abstract mixin class $WodLogEntryCopyWith<$Res>  {
  factory $WodLogEntryCopyWith(WodLogEntry value, $Res Function(WodLogEntry) _then) = _$WodLogEntryCopyWithImpl;
@useResult
$Res call({
 String wodKey, DateTime doneAt, DateTime wodDate, Branch branch, Program program, String? score, String? note
});




}
/// @nodoc
class _$WodLogEntryCopyWithImpl<$Res>
    implements $WodLogEntryCopyWith<$Res> {
  _$WodLogEntryCopyWithImpl(this._self, this._then);

  final WodLogEntry _self;
  final $Res Function(WodLogEntry) _then;

/// Create a copy of WodLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wodKey = null,Object? doneAt = null,Object? wodDate = null,Object? branch = null,Object? program = null,Object? score = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
wodKey: null == wodKey ? _self.wodKey : wodKey // ignore: cast_nullable_to_non_nullable
as String,doneAt: null == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime,wodDate: null == wodDate ? _self.wodDate : wodDate // ignore: cast_nullable_to_non_nullable
as DateTime,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as Program,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WodLogEntry].
extension WodLogEntryPatterns on WodLogEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WodLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WodLogEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WodLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _WodLogEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WodLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WodLogEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String wodKey,  DateTime doneAt,  DateTime wodDate,  Branch branch,  Program program,  String? score,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WodLogEntry() when $default != null:
return $default(_that.wodKey,_that.doneAt,_that.wodDate,_that.branch,_that.program,_that.score,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String wodKey,  DateTime doneAt,  DateTime wodDate,  Branch branch,  Program program,  String? score,  String? note)  $default,) {final _that = this;
switch (_that) {
case _WodLogEntry():
return $default(_that.wodKey,_that.doneAt,_that.wodDate,_that.branch,_that.program,_that.score,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String wodKey,  DateTime doneAt,  DateTime wodDate,  Branch branch,  Program program,  String? score,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _WodLogEntry() when $default != null:
return $default(_that.wodKey,_that.doneAt,_that.wodDate,_that.branch,_that.program,_that.score,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WodLogEntry implements WodLogEntry {
  const _WodLogEntry({required this.wodKey, required this.doneAt, required this.wodDate, required this.branch, required this.program, this.score, this.note});
  factory _WodLogEntry.fromJson(Map<String, dynamic> json) => _$WodLogEntryFromJson(json);

@override final  String wodKey;
@override final  DateTime doneAt;
@override final  DateTime wodDate;
@override final  Branch branch;
@override final  Program program;
@override final  String? score;
@override final  String? note;

/// Create a copy of WodLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WodLogEntryCopyWith<_WodLogEntry> get copyWith => __$WodLogEntryCopyWithImpl<_WodLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WodLogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WodLogEntry&&(identical(other.wodKey, wodKey) || other.wodKey == wodKey)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt)&&(identical(other.wodDate, wodDate) || other.wodDate == wodDate)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.program, program) || other.program == program)&&(identical(other.score, score) || other.score == score)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wodKey,doneAt,wodDate,branch,program,score,note);

@override
String toString() {
  return 'WodLogEntry(wodKey: $wodKey, doneAt: $doneAt, wodDate: $wodDate, branch: $branch, program: $program, score: $score, note: $note)';
}


}

/// @nodoc
abstract mixin class _$WodLogEntryCopyWith<$Res> implements $WodLogEntryCopyWith<$Res> {
  factory _$WodLogEntryCopyWith(_WodLogEntry value, $Res Function(_WodLogEntry) _then) = __$WodLogEntryCopyWithImpl;
@override @useResult
$Res call({
 String wodKey, DateTime doneAt, DateTime wodDate, Branch branch, Program program, String? score, String? note
});




}
/// @nodoc
class __$WodLogEntryCopyWithImpl<$Res>
    implements _$WodLogEntryCopyWith<$Res> {
  __$WodLogEntryCopyWithImpl(this._self, this._then);

  final _WodLogEntry _self;
  final $Res Function(_WodLogEntry) _then;

/// Create a copy of WodLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wodKey = null,Object? doneAt = null,Object? wodDate = null,Object? branch = null,Object? program = null,Object? score = freezed,Object? note = freezed,}) {
  return _then(_WodLogEntry(
wodKey: null == wodKey ? _self.wodKey : wodKey // ignore: cast_nullable_to_non_nullable
as String,doneAt: null == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime,wodDate: null == wodDate ? _self.wodDate : wodDate // ignore: cast_nullable_to_non_nullable
as DateTime,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as Program,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
