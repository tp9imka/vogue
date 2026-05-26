// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_timer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimerSpec {

 TimerMode get mode; Duration get total; Duration get work; Duration get rest; int get rounds;
/// Create a copy of TimerSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimerSpecCopyWith<TimerSpec> get copyWith => _$TimerSpecCopyWithImpl<TimerSpec>(this as TimerSpec, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimerSpec&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.total, total) || other.total == total)&&(identical(other.work, work) || other.work == work)&&(identical(other.rest, rest) || other.rest == rest)&&(identical(other.rounds, rounds) || other.rounds == rounds));
}


@override
int get hashCode => Object.hash(runtimeType,mode,total,work,rest,rounds);

@override
String toString() {
  return 'TimerSpec(mode: $mode, total: $total, work: $work, rest: $rest, rounds: $rounds)';
}


}

/// @nodoc
abstract mixin class $TimerSpecCopyWith<$Res>  {
  factory $TimerSpecCopyWith(TimerSpec value, $Res Function(TimerSpec) _then) = _$TimerSpecCopyWithImpl;
@useResult
$Res call({
 TimerMode mode, Duration total, Duration work, Duration rest, int rounds
});




}
/// @nodoc
class _$TimerSpecCopyWithImpl<$Res>
    implements $TimerSpecCopyWith<$Res> {
  _$TimerSpecCopyWithImpl(this._self, this._then);

  final TimerSpec _self;
  final $Res Function(TimerSpec) _then;

/// Create a copy of TimerSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? total = null,Object? work = null,Object? rest = null,Object? rounds = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TimerMode,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Duration,work: null == work ? _self.work : work // ignore: cast_nullable_to_non_nullable
as Duration,rest: null == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as Duration,rounds: null == rounds ? _self.rounds : rounds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TimerSpec].
extension TimerSpecPatterns on TimerSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimerSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimerSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimerSpec value)  $default,){
final _that = this;
switch (_that) {
case _TimerSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimerSpec value)?  $default,){
final _that = this;
switch (_that) {
case _TimerSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TimerMode mode,  Duration total,  Duration work,  Duration rest,  int rounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimerSpec() when $default != null:
return $default(_that.mode,_that.total,_that.work,_that.rest,_that.rounds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TimerMode mode,  Duration total,  Duration work,  Duration rest,  int rounds)  $default,) {final _that = this;
switch (_that) {
case _TimerSpec():
return $default(_that.mode,_that.total,_that.work,_that.rest,_that.rounds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TimerMode mode,  Duration total,  Duration work,  Duration rest,  int rounds)?  $default,) {final _that = this;
switch (_that) {
case _TimerSpec() when $default != null:
return $default(_that.mode,_that.total,_that.work,_that.rest,_that.rounds);case _:
  return null;

}
}

}

/// @nodoc


class _TimerSpec implements TimerSpec {
  const _TimerSpec({required this.mode, required this.total, this.work = Duration.zero, this.rest = Duration.zero, this.rounds = 1});
  

@override final  TimerMode mode;
@override final  Duration total;
@override@JsonKey() final  Duration work;
@override@JsonKey() final  Duration rest;
@override@JsonKey() final  int rounds;

/// Create a copy of TimerSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimerSpecCopyWith<_TimerSpec> get copyWith => __$TimerSpecCopyWithImpl<_TimerSpec>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimerSpec&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.total, total) || other.total == total)&&(identical(other.work, work) || other.work == work)&&(identical(other.rest, rest) || other.rest == rest)&&(identical(other.rounds, rounds) || other.rounds == rounds));
}


@override
int get hashCode => Object.hash(runtimeType,mode,total,work,rest,rounds);

@override
String toString() {
  return 'TimerSpec(mode: $mode, total: $total, work: $work, rest: $rest, rounds: $rounds)';
}


}

/// @nodoc
abstract mixin class _$TimerSpecCopyWith<$Res> implements $TimerSpecCopyWith<$Res> {
  factory _$TimerSpecCopyWith(_TimerSpec value, $Res Function(_TimerSpec) _then) = __$TimerSpecCopyWithImpl;
@override @useResult
$Res call({
 TimerMode mode, Duration total, Duration work, Duration rest, int rounds
});




}
/// @nodoc
class __$TimerSpecCopyWithImpl<$Res>
    implements _$TimerSpecCopyWith<$Res> {
  __$TimerSpecCopyWithImpl(this._self, this._then);

  final _TimerSpec _self;
  final $Res Function(_TimerSpec) _then;

/// Create a copy of TimerSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? total = null,Object? work = null,Object? rest = null,Object? rounds = null,}) {
  return _then(_TimerSpec(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TimerMode,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Duration,work: null == work ? _self.work : work // ignore: cast_nullable_to_non_nullable
as Duration,rest: null == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as Duration,rounds: null == rounds ? _self.rounds : rounds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TimerStateData {

 TimerSpec get spec; Duration get elapsed; bool get running; bool get finished;
/// Create a copy of TimerStateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimerStateDataCopyWith<TimerStateData> get copyWith => _$TimerStateDataCopyWithImpl<TimerStateData>(this as TimerStateData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimerStateData&&(identical(other.spec, spec) || other.spec == spec)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.running, running) || other.running == running)&&(identical(other.finished, finished) || other.finished == finished));
}


@override
int get hashCode => Object.hash(runtimeType,spec,elapsed,running,finished);

@override
String toString() {
  return 'TimerStateData(spec: $spec, elapsed: $elapsed, running: $running, finished: $finished)';
}


}

/// @nodoc
abstract mixin class $TimerStateDataCopyWith<$Res>  {
  factory $TimerStateDataCopyWith(TimerStateData value, $Res Function(TimerStateData) _then) = _$TimerStateDataCopyWithImpl;
@useResult
$Res call({
 TimerSpec spec, Duration elapsed, bool running, bool finished
});


$TimerSpecCopyWith<$Res> get spec;

}
/// @nodoc
class _$TimerStateDataCopyWithImpl<$Res>
    implements $TimerStateDataCopyWith<$Res> {
  _$TimerStateDataCopyWithImpl(this._self, this._then);

  final TimerStateData _self;
  final $Res Function(TimerStateData) _then;

/// Create a copy of TimerStateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spec = null,Object? elapsed = null,Object? running = null,Object? finished = null,}) {
  return _then(_self.copyWith(
spec: null == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as TimerSpec,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,running: null == running ? _self.running : running // ignore: cast_nullable_to_non_nullable
as bool,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TimerStateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimerSpecCopyWith<$Res> get spec {
  
  return $TimerSpecCopyWith<$Res>(_self.spec, (value) {
    return _then(_self.copyWith(spec: value));
  });
}
}


/// Adds pattern-matching-related methods to [TimerStateData].
extension TimerStateDataPatterns on TimerStateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimerStateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimerStateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimerStateData value)  $default,){
final _that = this;
switch (_that) {
case _TimerStateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimerStateData value)?  $default,){
final _that = this;
switch (_that) {
case _TimerStateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TimerSpec spec,  Duration elapsed,  bool running,  bool finished)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimerStateData() when $default != null:
return $default(_that.spec,_that.elapsed,_that.running,_that.finished);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TimerSpec spec,  Duration elapsed,  bool running,  bool finished)  $default,) {final _that = this;
switch (_that) {
case _TimerStateData():
return $default(_that.spec,_that.elapsed,_that.running,_that.finished);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TimerSpec spec,  Duration elapsed,  bool running,  bool finished)?  $default,) {final _that = this;
switch (_that) {
case _TimerStateData() when $default != null:
return $default(_that.spec,_that.elapsed,_that.running,_that.finished);case _:
  return null;

}
}

}

/// @nodoc


class _TimerStateData implements TimerStateData {
  const _TimerStateData({required this.spec, required this.elapsed, required this.running, required this.finished});
  

@override final  TimerSpec spec;
@override final  Duration elapsed;
@override final  bool running;
@override final  bool finished;

/// Create a copy of TimerStateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimerStateDataCopyWith<_TimerStateData> get copyWith => __$TimerStateDataCopyWithImpl<_TimerStateData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimerStateData&&(identical(other.spec, spec) || other.spec == spec)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.running, running) || other.running == running)&&(identical(other.finished, finished) || other.finished == finished));
}


@override
int get hashCode => Object.hash(runtimeType,spec,elapsed,running,finished);

@override
String toString() {
  return 'TimerStateData(spec: $spec, elapsed: $elapsed, running: $running, finished: $finished)';
}


}

/// @nodoc
abstract mixin class _$TimerStateDataCopyWith<$Res> implements $TimerStateDataCopyWith<$Res> {
  factory _$TimerStateDataCopyWith(_TimerStateData value, $Res Function(_TimerStateData) _then) = __$TimerStateDataCopyWithImpl;
@override @useResult
$Res call({
 TimerSpec spec, Duration elapsed, bool running, bool finished
});


@override $TimerSpecCopyWith<$Res> get spec;

}
/// @nodoc
class __$TimerStateDataCopyWithImpl<$Res>
    implements _$TimerStateDataCopyWith<$Res> {
  __$TimerStateDataCopyWithImpl(this._self, this._then);

  final _TimerStateData _self;
  final $Res Function(_TimerStateData) _then;

/// Create a copy of TimerStateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spec = null,Object? elapsed = null,Object? running = null,Object? finished = null,}) {
  return _then(_TimerStateData(
spec: null == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as TimerSpec,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,running: null == running ? _self.running : running // ignore: cast_nullable_to_non_nullable
as bool,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TimerStateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimerSpecCopyWith<$Res> get spec {
  
  return $TimerSpecCopyWith<$Res>(_self.spec, (value) {
    return _then(_self.copyWith(spec: value));
  });
}
}

// dart format on
