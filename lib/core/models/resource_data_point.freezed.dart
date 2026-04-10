// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resource_data_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResourceDataPoint {

 DateTime get timestamp; double? get cpu; double? get mem; double? get netIn; double? get netOut; double? get diskRead; double? get diskWrite;
/// Create a copy of ResourceDataPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResourceDataPointCopyWith<ResourceDataPoint> get copyWith => _$ResourceDataPointCopyWithImpl<ResourceDataPoint>(this as ResourceDataPoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResourceDataPoint&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.mem, mem) || other.mem == mem)&&(identical(other.netIn, netIn) || other.netIn == netIn)&&(identical(other.netOut, netOut) || other.netOut == netOut)&&(identical(other.diskRead, diskRead) || other.diskRead == diskRead)&&(identical(other.diskWrite, diskWrite) || other.diskWrite == diskWrite));
}


@override
int get hashCode => Object.hash(runtimeType,timestamp,cpu,mem,netIn,netOut,diskRead,diskWrite);

@override
String toString() {
  return 'ResourceDataPoint(timestamp: $timestamp, cpu: $cpu, mem: $mem, netIn: $netIn, netOut: $netOut, diskRead: $diskRead, diskWrite: $diskWrite)';
}


}

/// @nodoc
abstract mixin class $ResourceDataPointCopyWith<$Res>  {
  factory $ResourceDataPointCopyWith(ResourceDataPoint value, $Res Function(ResourceDataPoint) _then) = _$ResourceDataPointCopyWithImpl;
@useResult
$Res call({
 DateTime timestamp, double? cpu, double? mem, double? netIn, double? netOut, double? diskRead, double? diskWrite
});




}
/// @nodoc
class _$ResourceDataPointCopyWithImpl<$Res>
    implements $ResourceDataPointCopyWith<$Res> {
  _$ResourceDataPointCopyWithImpl(this._self, this._then);

  final ResourceDataPoint _self;
  final $Res Function(ResourceDataPoint) _then;

/// Create a copy of ResourceDataPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = null,Object? cpu = freezed,Object? mem = freezed,Object? netIn = freezed,Object? netOut = freezed,Object? diskRead = freezed,Object? diskWrite = freezed,}) {
  return _then(_self.copyWith(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as double?,mem: freezed == mem ? _self.mem : mem // ignore: cast_nullable_to_non_nullable
as double?,netIn: freezed == netIn ? _self.netIn : netIn // ignore: cast_nullable_to_non_nullable
as double?,netOut: freezed == netOut ? _self.netOut : netOut // ignore: cast_nullable_to_non_nullable
as double?,diskRead: freezed == diskRead ? _self.diskRead : diskRead // ignore: cast_nullable_to_non_nullable
as double?,diskWrite: freezed == diskWrite ? _self.diskWrite : diskWrite // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResourceDataPoint].
extension ResourceDataPointPatterns on ResourceDataPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResourceDataPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResourceDataPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResourceDataPoint value)  $default,){
final _that = this;
switch (_that) {
case _ResourceDataPoint():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResourceDataPoint value)?  $default,){
final _that = this;
switch (_that) {
case _ResourceDataPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime timestamp,  double? cpu,  double? mem,  double? netIn,  double? netOut,  double? diskRead,  double? diskWrite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResourceDataPoint() when $default != null:
return $default(_that.timestamp,_that.cpu,_that.mem,_that.netIn,_that.netOut,_that.diskRead,_that.diskWrite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime timestamp,  double? cpu,  double? mem,  double? netIn,  double? netOut,  double? diskRead,  double? diskWrite)  $default,) {final _that = this;
switch (_that) {
case _ResourceDataPoint():
return $default(_that.timestamp,_that.cpu,_that.mem,_that.netIn,_that.netOut,_that.diskRead,_that.diskWrite);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime timestamp,  double? cpu,  double? mem,  double? netIn,  double? netOut,  double? diskRead,  double? diskWrite)?  $default,) {final _that = this;
switch (_that) {
case _ResourceDataPoint() when $default != null:
return $default(_that.timestamp,_that.cpu,_that.mem,_that.netIn,_that.netOut,_that.diskRead,_that.diskWrite);case _:
  return null;

}
}

}

/// @nodoc


class _ResourceDataPoint implements ResourceDataPoint {
  const _ResourceDataPoint({required this.timestamp, this.cpu, this.mem, this.netIn, this.netOut, this.diskRead, this.diskWrite});
  

@override final  DateTime timestamp;
@override final  double? cpu;
@override final  double? mem;
@override final  double? netIn;
@override final  double? netOut;
@override final  double? diskRead;
@override final  double? diskWrite;

/// Create a copy of ResourceDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResourceDataPointCopyWith<_ResourceDataPoint> get copyWith => __$ResourceDataPointCopyWithImpl<_ResourceDataPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResourceDataPoint&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.mem, mem) || other.mem == mem)&&(identical(other.netIn, netIn) || other.netIn == netIn)&&(identical(other.netOut, netOut) || other.netOut == netOut)&&(identical(other.diskRead, diskRead) || other.diskRead == diskRead)&&(identical(other.diskWrite, diskWrite) || other.diskWrite == diskWrite));
}


@override
int get hashCode => Object.hash(runtimeType,timestamp,cpu,mem,netIn,netOut,diskRead,diskWrite);

@override
String toString() {
  return 'ResourceDataPoint(timestamp: $timestamp, cpu: $cpu, mem: $mem, netIn: $netIn, netOut: $netOut, diskRead: $diskRead, diskWrite: $diskWrite)';
}


}

/// @nodoc
abstract mixin class _$ResourceDataPointCopyWith<$Res> implements $ResourceDataPointCopyWith<$Res> {
  factory _$ResourceDataPointCopyWith(_ResourceDataPoint value, $Res Function(_ResourceDataPoint) _then) = __$ResourceDataPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime timestamp, double? cpu, double? mem, double? netIn, double? netOut, double? diskRead, double? diskWrite
});




}
/// @nodoc
class __$ResourceDataPointCopyWithImpl<$Res>
    implements _$ResourceDataPointCopyWith<$Res> {
  __$ResourceDataPointCopyWithImpl(this._self, this._then);

  final _ResourceDataPoint _self;
  final $Res Function(_ResourceDataPoint) _then;

/// Create a copy of ResourceDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = null,Object? cpu = freezed,Object? mem = freezed,Object? netIn = freezed,Object? netOut = freezed,Object? diskRead = freezed,Object? diskWrite = freezed,}) {
  return _then(_ResourceDataPoint(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as double?,mem: freezed == mem ? _self.mem : mem // ignore: cast_nullable_to_non_nullable
as double?,netIn: freezed == netIn ? _self.netIn : netIn // ignore: cast_nullable_to_non_nullable
as double?,netOut: freezed == netOut ? _self.netOut : netOut // ignore: cast_nullable_to_non_nullable
as double?,diskRead: freezed == diskRead ? _self.diskRead : diskRead // ignore: cast_nullable_to_non_nullable
as double?,diskWrite: freezed == diskWrite ? _self.diskWrite : diskWrite // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
