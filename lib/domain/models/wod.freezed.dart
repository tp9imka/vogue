// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wod.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Wod {

 DateTime get date; Branch get branch; Program get program; List<WodSection> get sections; String? get note;
/// Create a copy of Wod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WodCopyWith<Wod> get copyWith => _$WodCopyWithImpl<Wod>(this as Wod, _$identity);

  /// Serializes this Wod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wod&&(identical(other.date, date) || other.date == date)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.program, program) || other.program == program)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,branch,program,const DeepCollectionEquality().hash(sections),note);

@override
String toString() {
  return 'Wod(date: $date, branch: $branch, program: $program, sections: $sections, note: $note)';
}


}

/// @nodoc
abstract mixin class $WodCopyWith<$Res>  {
  factory $WodCopyWith(Wod value, $Res Function(Wod) _then) = _$WodCopyWithImpl;
@useResult
$Res call({
 DateTime date, Branch branch, Program program, List<WodSection> sections, String? note
});




}
/// @nodoc
class _$WodCopyWithImpl<$Res>
    implements $WodCopyWith<$Res> {
  _$WodCopyWithImpl(this._self, this._then);

  final Wod _self;
  final $Res Function(Wod) _then;

/// Create a copy of Wod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? branch = null,Object? program = null,Object? sections = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as Program,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<WodSection>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Wod].
extension WodPatterns on Wod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Wod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Wod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Wod value)  $default,){
final _that = this;
switch (_that) {
case _Wod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Wod value)?  $default,){
final _that = this;
switch (_that) {
case _Wod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  Branch branch,  Program program,  List<WodSection> sections,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Wod() when $default != null:
return $default(_that.date,_that.branch,_that.program,_that.sections,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  Branch branch,  Program program,  List<WodSection> sections,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Wod():
return $default(_that.date,_that.branch,_that.program,_that.sections,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  Branch branch,  Program program,  List<WodSection> sections,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Wod() when $default != null:
return $default(_that.date,_that.branch,_that.program,_that.sections,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Wod implements Wod {
  const _Wod({required this.date, required this.branch, required this.program, required final  List<WodSection> sections, this.note}): _sections = sections;
  factory _Wod.fromJson(Map<String, dynamic> json) => _$WodFromJson(json);

@override final  DateTime date;
@override final  Branch branch;
@override final  Program program;
 final  List<WodSection> _sections;
@override List<WodSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override final  String? note;

/// Create a copy of Wod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WodCopyWith<_Wod> get copyWith => __$WodCopyWithImpl<_Wod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wod&&(identical(other.date, date) || other.date == date)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.program, program) || other.program == program)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,branch,program,const DeepCollectionEquality().hash(_sections),note);

@override
String toString() {
  return 'Wod(date: $date, branch: $branch, program: $program, sections: $sections, note: $note)';
}


}

/// @nodoc
abstract mixin class _$WodCopyWith<$Res> implements $WodCopyWith<$Res> {
  factory _$WodCopyWith(_Wod value, $Res Function(_Wod) _then) = __$WodCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, Branch branch, Program program, List<WodSection> sections, String? note
});




}
/// @nodoc
class __$WodCopyWithImpl<$Res>
    implements _$WodCopyWith<$Res> {
  __$WodCopyWithImpl(this._self, this._then);

  final _Wod _self;
  final $Res Function(_Wod) _then;

/// Create a copy of Wod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? branch = null,Object? program = null,Object? sections = null,Object? note = freezed,}) {
  return _then(_Wod(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as Branch,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as Program,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<WodSection>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
