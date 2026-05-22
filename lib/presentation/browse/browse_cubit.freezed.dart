// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'browse_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrowseState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowseState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BrowseState()';
}


}

/// @nodoc
class $BrowseStateCopyWith<$Res>  {
$BrowseStateCopyWith(BrowseState _, $Res Function(BrowseState) __);
}


/// Adds pattern-matching-related methods to [BrowseState].
extension BrowseStatePatterns on BrowseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BrowseLoading value)?  loading,TResult Function( BrowseReady value)?  ready,TResult Function( BrowseError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BrowseLoading() when loading != null:
return loading(_that);case BrowseReady() when ready != null:
return ready(_that);case BrowseError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BrowseLoading value)  loading,required TResult Function( BrowseReady value)  ready,required TResult Function( BrowseError value)  error,}){
final _that = this;
switch (_that) {
case BrowseLoading():
return loading(_that);case BrowseReady():
return ready(_that);case BrowseError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BrowseLoading value)?  loading,TResult? Function( BrowseReady value)?  ready,TResult? Function( BrowseError value)?  error,}){
final _that = this;
switch (_that) {
case BrowseLoading() when loading != null:
return loading(_that);case BrowseReady() when ready != null:
return ready(_that);case BrowseError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( DateTime selectedDate,  DateTime today,  List<DateTime> availableDates,  List<Wod> wods,  bool stale)?  ready,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BrowseLoading() when loading != null:
return loading();case BrowseReady() when ready != null:
return ready(_that.selectedDate,_that.today,_that.availableDates,_that.wods,_that.stale);case BrowseError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( DateTime selectedDate,  DateTime today,  List<DateTime> availableDates,  List<Wod> wods,  bool stale)  ready,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case BrowseLoading():
return loading();case BrowseReady():
return ready(_that.selectedDate,_that.today,_that.availableDates,_that.wods,_that.stale);case BrowseError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( DateTime selectedDate,  DateTime today,  List<DateTime> availableDates,  List<Wod> wods,  bool stale)?  ready,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case BrowseLoading() when loading != null:
return loading();case BrowseReady() when ready != null:
return ready(_that.selectedDate,_that.today,_that.availableDates,_that.wods,_that.stale);case BrowseError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class BrowseLoading implements BrowseState {
  const BrowseLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowseLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BrowseState.loading()';
}


}




/// @nodoc


class BrowseReady implements BrowseState {
  const BrowseReady({required this.selectedDate, required this.today, required final  List<DateTime> availableDates, required final  List<Wod> wods, required this.stale}): _availableDates = availableDates,_wods = wods;
  

 final  DateTime selectedDate;
 final  DateTime today;
 final  List<DateTime> _availableDates;
 List<DateTime> get availableDates {
  if (_availableDates is EqualUnmodifiableListView) return _availableDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableDates);
}

 final  List<Wod> _wods;
 List<Wod> get wods {
  if (_wods is EqualUnmodifiableListView) return _wods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wods);
}

 final  bool stale;

/// Create a copy of BrowseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrowseReadyCopyWith<BrowseReady> get copyWith => _$BrowseReadyCopyWithImpl<BrowseReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowseReady&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.today, today) || other.today == today)&&const DeepCollectionEquality().equals(other._availableDates, _availableDates)&&const DeepCollectionEquality().equals(other._wods, _wods)&&(identical(other.stale, stale) || other.stale == stale));
}


@override
int get hashCode => Object.hash(runtimeType,selectedDate,today,const DeepCollectionEquality().hash(_availableDates),const DeepCollectionEquality().hash(_wods),stale);

@override
String toString() {
  return 'BrowseState.ready(selectedDate: $selectedDate, today: $today, availableDates: $availableDates, wods: $wods, stale: $stale)';
}


}

/// @nodoc
abstract mixin class $BrowseReadyCopyWith<$Res> implements $BrowseStateCopyWith<$Res> {
  factory $BrowseReadyCopyWith(BrowseReady value, $Res Function(BrowseReady) _then) = _$BrowseReadyCopyWithImpl;
@useResult
$Res call({
 DateTime selectedDate, DateTime today, List<DateTime> availableDates, List<Wod> wods, bool stale
});




}
/// @nodoc
class _$BrowseReadyCopyWithImpl<$Res>
    implements $BrowseReadyCopyWith<$Res> {
  _$BrowseReadyCopyWithImpl(this._self, this._then);

  final BrowseReady _self;
  final $Res Function(BrowseReady) _then;

/// Create a copy of BrowseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selectedDate = null,Object? today = null,Object? availableDates = null,Object? wods = null,Object? stale = null,}) {
  return _then(BrowseReady(
selectedDate: null == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,availableDates: null == availableDates ? _self._availableDates : availableDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,wods: null == wods ? _self._wods : wods // ignore: cast_nullable_to_non_nullable
as List<Wod>,stale: null == stale ? _self.stale : stale // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class BrowseError implements BrowseState {
  const BrowseError(this.message);
  

 final  String message;

/// Create a copy of BrowseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrowseErrorCopyWith<BrowseError> get copyWith => _$BrowseErrorCopyWithImpl<BrowseError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowseError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BrowseState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $BrowseErrorCopyWith<$Res> implements $BrowseStateCopyWith<$Res> {
  factory $BrowseErrorCopyWith(BrowseError value, $Res Function(BrowseError) _then) = _$BrowseErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$BrowseErrorCopyWithImpl<$Res>
    implements $BrowseErrorCopyWith<$Res> {
  _$BrowseErrorCopyWithImpl(this._self, this._then);

  final BrowseError _self;
  final $Res Function(BrowseError) _then;

/// Create a copy of BrowseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(BrowseError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
