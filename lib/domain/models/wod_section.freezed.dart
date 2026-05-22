// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wod_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WodSection {

 List<String> get lines; String? get title;
/// Create a copy of WodSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WodSectionCopyWith<WodSection> get copyWith => _$WodSectionCopyWithImpl<WodSection>(this as WodSection, _$identity);

  /// Serializes this WodSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WodSection&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(lines),title);

@override
String toString() {
  return 'WodSection(lines: $lines, title: $title)';
}


}

/// @nodoc
abstract mixin class $WodSectionCopyWith<$Res>  {
  factory $WodSectionCopyWith(WodSection value, $Res Function(WodSection) _then) = _$WodSectionCopyWithImpl;
@useResult
$Res call({
 List<String> lines, String? title
});




}
/// @nodoc
class _$WodSectionCopyWithImpl<$Res>
    implements $WodSectionCopyWith<$Res> {
  _$WodSectionCopyWithImpl(this._self, this._then);

  final WodSection _self;
  final $Res Function(WodSection) _then;

/// Create a copy of WodSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lines = null,Object? title = freezed,}) {
  return _then(_self.copyWith(
lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<String>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WodSection].
extension WodSectionPatterns on WodSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WodSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WodSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WodSection value)  $default,){
final _that = this;
switch (_that) {
case _WodSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WodSection value)?  $default,){
final _that = this;
switch (_that) {
case _WodSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> lines,  String? title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WodSection() when $default != null:
return $default(_that.lines,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> lines,  String? title)  $default,) {final _that = this;
switch (_that) {
case _WodSection():
return $default(_that.lines,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> lines,  String? title)?  $default,) {final _that = this;
switch (_that) {
case _WodSection() when $default != null:
return $default(_that.lines,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WodSection implements WodSection {
  const _WodSection({required final  List<String> lines, this.title}): _lines = lines;
  factory _WodSection.fromJson(Map<String, dynamic> json) => _$WodSectionFromJson(json);

 final  List<String> _lines;
@override List<String> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  String? title;

/// Create a copy of WodSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WodSectionCopyWith<_WodSection> get copyWith => __$WodSectionCopyWithImpl<_WodSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WodSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WodSection&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_lines),title);

@override
String toString() {
  return 'WodSection(lines: $lines, title: $title)';
}


}

/// @nodoc
abstract mixin class _$WodSectionCopyWith<$Res> implements $WodSectionCopyWith<$Res> {
  factory _$WodSectionCopyWith(_WodSection value, $Res Function(_WodSection) _then) = __$WodSectionCopyWithImpl;
@override @useResult
$Res call({
 List<String> lines, String? title
});




}
/// @nodoc
class __$WodSectionCopyWithImpl<$Res>
    implements _$WodSectionCopyWith<$Res> {
  __$WodSectionCopyWithImpl(this._self, this._then);

  final _WodSection _self;
  final $Res Function(_WodSection) _then;

/// Create a copy of WodSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lines = null,Object? title = freezed,}) {
  return _then(_WodSection(
lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<String>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
