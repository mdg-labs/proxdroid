// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Node {

 String get name; String? get status; double? get cpu; int? get maxCpu; int? get mem; int? get maxMem; int? get uptime;
/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NodeCopyWith<Node> get copyWith => _$NodeCopyWithImpl<Node>(this as Node, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Node&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.maxCpu, maxCpu) || other.maxCpu == maxCpu)&&(identical(other.mem, mem) || other.mem == mem)&&(identical(other.maxMem, maxMem) || other.maxMem == maxMem)&&(identical(other.uptime, uptime) || other.uptime == uptime));
}


@override
int get hashCode => Object.hash(runtimeType,name,status,cpu,maxCpu,mem,maxMem,uptime);

@override
String toString() {
  return 'Node(name: $name, status: $status, cpu: $cpu, maxCpu: $maxCpu, mem: $mem, maxMem: $maxMem, uptime: $uptime)';
}


}

/// @nodoc
abstract mixin class $NodeCopyWith<$Res>  {
  factory $NodeCopyWith(Node value, $Res Function(Node) _then) = _$NodeCopyWithImpl;
@useResult
$Res call({
 String name, String? status, double? cpu, int? maxCpu, int? mem, int? maxMem, int? uptime
});




}
/// @nodoc
class _$NodeCopyWithImpl<$Res>
    implements $NodeCopyWith<$Res> {
  _$NodeCopyWithImpl(this._self, this._then);

  final Node _self;
  final $Res Function(Node) _then;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? status = freezed,Object? cpu = freezed,Object? maxCpu = freezed,Object? mem = freezed,Object? maxMem = freezed,Object? uptime = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as double?,maxCpu: freezed == maxCpu ? _self.maxCpu : maxCpu // ignore: cast_nullable_to_non_nullable
as int?,mem: freezed == mem ? _self.mem : mem // ignore: cast_nullable_to_non_nullable
as int?,maxMem: freezed == maxMem ? _self.maxMem : maxMem // ignore: cast_nullable_to_non_nullable
as int?,uptime: freezed == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Node].
extension NodePatterns on Node {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Node value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Node() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Node value)  $default,){
final _that = this;
switch (_that) {
case _Node():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Node value)?  $default,){
final _that = this;
switch (_that) {
case _Node() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? status,  double? cpu,  int? maxCpu,  int? mem,  int? maxMem,  int? uptime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Node() when $default != null:
return $default(_that.name,_that.status,_that.cpu,_that.maxCpu,_that.mem,_that.maxMem,_that.uptime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? status,  double? cpu,  int? maxCpu,  int? mem,  int? maxMem,  int? uptime)  $default,) {final _that = this;
switch (_that) {
case _Node():
return $default(_that.name,_that.status,_that.cpu,_that.maxCpu,_that.mem,_that.maxMem,_that.uptime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? status,  double? cpu,  int? maxCpu,  int? mem,  int? maxMem,  int? uptime)?  $default,) {final _that = this;
switch (_that) {
case _Node() when $default != null:
return $default(_that.name,_that.status,_that.cpu,_that.maxCpu,_that.mem,_that.maxMem,_that.uptime);case _:
  return null;

}
}

}

/// @nodoc


class _Node implements Node {
  const _Node({required this.name, this.status, this.cpu, this.maxCpu, this.mem, this.maxMem, this.uptime});
  

@override final  String name;
@override final  String? status;
@override final  double? cpu;
@override final  int? maxCpu;
@override final  int? mem;
@override final  int? maxMem;
@override final  int? uptime;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NodeCopyWith<_Node> get copyWith => __$NodeCopyWithImpl<_Node>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Node&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.maxCpu, maxCpu) || other.maxCpu == maxCpu)&&(identical(other.mem, mem) || other.mem == mem)&&(identical(other.maxMem, maxMem) || other.maxMem == maxMem)&&(identical(other.uptime, uptime) || other.uptime == uptime));
}


@override
int get hashCode => Object.hash(runtimeType,name,status,cpu,maxCpu,mem,maxMem,uptime);

@override
String toString() {
  return 'Node(name: $name, status: $status, cpu: $cpu, maxCpu: $maxCpu, mem: $mem, maxMem: $maxMem, uptime: $uptime)';
}


}

/// @nodoc
abstract mixin class _$NodeCopyWith<$Res> implements $NodeCopyWith<$Res> {
  factory _$NodeCopyWith(_Node value, $Res Function(_Node) _then) = __$NodeCopyWithImpl;
@override @useResult
$Res call({
 String name, String? status, double? cpu, int? maxCpu, int? mem, int? maxMem, int? uptime
});




}
/// @nodoc
class __$NodeCopyWithImpl<$Res>
    implements _$NodeCopyWith<$Res> {
  __$NodeCopyWithImpl(this._self, this._then);

  final _Node _self;
  final $Res Function(_Node) _then;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = freezed,Object? cpu = freezed,Object? maxCpu = freezed,Object? mem = freezed,Object? maxMem = freezed,Object? uptime = freezed,}) {
  return _then(_Node(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as double?,maxCpu: freezed == maxCpu ? _self.maxCpu : maxCpu // ignore: cast_nullable_to_non_nullable
as int?,mem: freezed == mem ? _self.mem : mem // ignore: cast_nullable_to_non_nullable
as int?,maxMem: freezed == maxMem ? _self.maxMem : maxMem // ignore: cast_nullable_to_non_nullable
as int?,uptime: freezed == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
