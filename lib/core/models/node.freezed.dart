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

@JsonKey(name: 'node') String get name; String? get status;@JsonKey(fromJson: proxmoxDouble) double? get cpu;@JsonKey(name: 'maxcpu', fromJson: proxmoxInt) int? get maxCpu;@JsonKey(fromJson: proxmoxInt) int? get mem;@JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? get maxMem;@JsonKey(fromJson: proxmoxInt) int? get disk;@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? get maxDisk;@JsonKey(fromJson: proxmoxInt) int? get uptime;@JsonKey(name: 'ssl_fingerprint') String? get sslFingerprint; String? get level;/// From [GET /nodes/{node}/status] `swap` map (flattened by the API client).
@JsonKey(name: 'swapused', fromJson: proxmoxInt) int? get swapUsed;@JsonKey(name: 'swaptotal', fromJson: proxmoxInt) int? get swapTotal;/// First value of Proxmox `loadavg` (1 minute).
@JsonKey(name: 'loadavg1m', fromJson: proxmoxDouble) double? get loadavg1m;/// CPU I/O wait when exposed by the node status payload.
@JsonKey(name: 'iowait', fromJson: proxmoxDouble) double? get ioWait;
/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NodeCopyWith<Node> get copyWith => _$NodeCopyWithImpl<Node>(this as Node, _$identity);

  /// Serializes this Node to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Node&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.maxCpu, maxCpu) || other.maxCpu == maxCpu)&&(identical(other.mem, mem) || other.mem == mem)&&(identical(other.maxMem, maxMem) || other.maxMem == maxMem)&&(identical(other.disk, disk) || other.disk == disk)&&(identical(other.maxDisk, maxDisk) || other.maxDisk == maxDisk)&&(identical(other.uptime, uptime) || other.uptime == uptime)&&(identical(other.sslFingerprint, sslFingerprint) || other.sslFingerprint == sslFingerprint)&&(identical(other.level, level) || other.level == level)&&(identical(other.swapUsed, swapUsed) || other.swapUsed == swapUsed)&&(identical(other.swapTotal, swapTotal) || other.swapTotal == swapTotal)&&(identical(other.loadavg1m, loadavg1m) || other.loadavg1m == loadavg1m)&&(identical(other.ioWait, ioWait) || other.ioWait == ioWait));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,status,cpu,maxCpu,mem,maxMem,disk,maxDisk,uptime,sslFingerprint,level,swapUsed,swapTotal,loadavg1m,ioWait);

@override
String toString() {
  return 'Node(name: $name, status: $status, cpu: $cpu, maxCpu: $maxCpu, mem: $mem, maxMem: $maxMem, disk: $disk, maxDisk: $maxDisk, uptime: $uptime, sslFingerprint: $sslFingerprint, level: $level, swapUsed: $swapUsed, swapTotal: $swapTotal, loadavg1m: $loadavg1m, ioWait: $ioWait)';
}


}

/// @nodoc
abstract mixin class $NodeCopyWith<$Res>  {
  factory $NodeCopyWith(Node value, $Res Function(Node) _then) = _$NodeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'node') String name, String? status,@JsonKey(fromJson: proxmoxDouble) double? cpu,@JsonKey(name: 'maxcpu', fromJson: proxmoxInt) int? maxCpu,@JsonKey(fromJson: proxmoxInt) int? mem,@JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? maxMem,@JsonKey(fromJson: proxmoxInt) int? disk,@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? maxDisk,@JsonKey(fromJson: proxmoxInt) int? uptime,@JsonKey(name: 'ssl_fingerprint') String? sslFingerprint, String? level,@JsonKey(name: 'swapused', fromJson: proxmoxInt) int? swapUsed,@JsonKey(name: 'swaptotal', fromJson: proxmoxInt) int? swapTotal,@JsonKey(name: 'loadavg1m', fromJson: proxmoxDouble) double? loadavg1m,@JsonKey(name: 'iowait', fromJson: proxmoxDouble) double? ioWait
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? status = freezed,Object? cpu = freezed,Object? maxCpu = freezed,Object? mem = freezed,Object? maxMem = freezed,Object? disk = freezed,Object? maxDisk = freezed,Object? uptime = freezed,Object? sslFingerprint = freezed,Object? level = freezed,Object? swapUsed = freezed,Object? swapTotal = freezed,Object? loadavg1m = freezed,Object? ioWait = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as double?,maxCpu: freezed == maxCpu ? _self.maxCpu : maxCpu // ignore: cast_nullable_to_non_nullable
as int?,mem: freezed == mem ? _self.mem : mem // ignore: cast_nullable_to_non_nullable
as int?,maxMem: freezed == maxMem ? _self.maxMem : maxMem // ignore: cast_nullable_to_non_nullable
as int?,disk: freezed == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int?,maxDisk: freezed == maxDisk ? _self.maxDisk : maxDisk // ignore: cast_nullable_to_non_nullable
as int?,uptime: freezed == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int?,sslFingerprint: freezed == sslFingerprint ? _self.sslFingerprint : sslFingerprint // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,swapUsed: freezed == swapUsed ? _self.swapUsed : swapUsed // ignore: cast_nullable_to_non_nullable
as int?,swapTotal: freezed == swapTotal ? _self.swapTotal : swapTotal // ignore: cast_nullable_to_non_nullable
as int?,loadavg1m: freezed == loadavg1m ? _self.loadavg1m : loadavg1m // ignore: cast_nullable_to_non_nullable
as double?,ioWait: freezed == ioWait ? _self.ioWait : ioWait // ignore: cast_nullable_to_non_nullable
as double?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'node')  String name,  String? status, @JsonKey(fromJson: proxmoxDouble)  double? cpu, @JsonKey(name: 'maxcpu', fromJson: proxmoxInt)  int? maxCpu, @JsonKey(fromJson: proxmoxInt)  int? mem, @JsonKey(name: 'maxmem', fromJson: proxmoxInt)  int? maxMem, @JsonKey(fromJson: proxmoxInt)  int? disk, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt)  int? maxDisk, @JsonKey(fromJson: proxmoxInt)  int? uptime, @JsonKey(name: 'ssl_fingerprint')  String? sslFingerprint,  String? level, @JsonKey(name: 'swapused', fromJson: proxmoxInt)  int? swapUsed, @JsonKey(name: 'swaptotal', fromJson: proxmoxInt)  int? swapTotal, @JsonKey(name: 'loadavg1m', fromJson: proxmoxDouble)  double? loadavg1m, @JsonKey(name: 'iowait', fromJson: proxmoxDouble)  double? ioWait)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Node() when $default != null:
return $default(_that.name,_that.status,_that.cpu,_that.maxCpu,_that.mem,_that.maxMem,_that.disk,_that.maxDisk,_that.uptime,_that.sslFingerprint,_that.level,_that.swapUsed,_that.swapTotal,_that.loadavg1m,_that.ioWait);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'node')  String name,  String? status, @JsonKey(fromJson: proxmoxDouble)  double? cpu, @JsonKey(name: 'maxcpu', fromJson: proxmoxInt)  int? maxCpu, @JsonKey(fromJson: proxmoxInt)  int? mem, @JsonKey(name: 'maxmem', fromJson: proxmoxInt)  int? maxMem, @JsonKey(fromJson: proxmoxInt)  int? disk, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt)  int? maxDisk, @JsonKey(fromJson: proxmoxInt)  int? uptime, @JsonKey(name: 'ssl_fingerprint')  String? sslFingerprint,  String? level, @JsonKey(name: 'swapused', fromJson: proxmoxInt)  int? swapUsed, @JsonKey(name: 'swaptotal', fromJson: proxmoxInt)  int? swapTotal, @JsonKey(name: 'loadavg1m', fromJson: proxmoxDouble)  double? loadavg1m, @JsonKey(name: 'iowait', fromJson: proxmoxDouble)  double? ioWait)  $default,) {final _that = this;
switch (_that) {
case _Node():
return $default(_that.name,_that.status,_that.cpu,_that.maxCpu,_that.mem,_that.maxMem,_that.disk,_that.maxDisk,_that.uptime,_that.sslFingerprint,_that.level,_that.swapUsed,_that.swapTotal,_that.loadavg1m,_that.ioWait);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'node')  String name,  String? status, @JsonKey(fromJson: proxmoxDouble)  double? cpu, @JsonKey(name: 'maxcpu', fromJson: proxmoxInt)  int? maxCpu, @JsonKey(fromJson: proxmoxInt)  int? mem, @JsonKey(name: 'maxmem', fromJson: proxmoxInt)  int? maxMem, @JsonKey(fromJson: proxmoxInt)  int? disk, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt)  int? maxDisk, @JsonKey(fromJson: proxmoxInt)  int? uptime, @JsonKey(name: 'ssl_fingerprint')  String? sslFingerprint,  String? level, @JsonKey(name: 'swapused', fromJson: proxmoxInt)  int? swapUsed, @JsonKey(name: 'swaptotal', fromJson: proxmoxInt)  int? swapTotal, @JsonKey(name: 'loadavg1m', fromJson: proxmoxDouble)  double? loadavg1m, @JsonKey(name: 'iowait', fromJson: proxmoxDouble)  double? ioWait)?  $default,) {final _that = this;
switch (_that) {
case _Node() when $default != null:
return $default(_that.name,_that.status,_that.cpu,_that.maxCpu,_that.mem,_that.maxMem,_that.disk,_that.maxDisk,_that.uptime,_that.sslFingerprint,_that.level,_that.swapUsed,_that.swapTotal,_that.loadavg1m,_that.ioWait);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Node implements Node {
  const _Node({@JsonKey(name: 'node') required this.name, this.status, @JsonKey(fromJson: proxmoxDouble) this.cpu, @JsonKey(name: 'maxcpu', fromJson: proxmoxInt) this.maxCpu, @JsonKey(fromJson: proxmoxInt) this.mem, @JsonKey(name: 'maxmem', fromJson: proxmoxInt) this.maxMem, @JsonKey(fromJson: proxmoxInt) this.disk, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt) this.maxDisk, @JsonKey(fromJson: proxmoxInt) this.uptime, @JsonKey(name: 'ssl_fingerprint') this.sslFingerprint, this.level, @JsonKey(name: 'swapused', fromJson: proxmoxInt) this.swapUsed, @JsonKey(name: 'swaptotal', fromJson: proxmoxInt) this.swapTotal, @JsonKey(name: 'loadavg1m', fromJson: proxmoxDouble) this.loadavg1m, @JsonKey(name: 'iowait', fromJson: proxmoxDouble) this.ioWait});
  factory _Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);

@override@JsonKey(name: 'node') final  String name;
@override final  String? status;
@override@JsonKey(fromJson: proxmoxDouble) final  double? cpu;
@override@JsonKey(name: 'maxcpu', fromJson: proxmoxInt) final  int? maxCpu;
@override@JsonKey(fromJson: proxmoxInt) final  int? mem;
@override@JsonKey(name: 'maxmem', fromJson: proxmoxInt) final  int? maxMem;
@override@JsonKey(fromJson: proxmoxInt) final  int? disk;
@override@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) final  int? maxDisk;
@override@JsonKey(fromJson: proxmoxInt) final  int? uptime;
@override@JsonKey(name: 'ssl_fingerprint') final  String? sslFingerprint;
@override final  String? level;
/// From [GET /nodes/{node}/status] `swap` map (flattened by the API client).
@override@JsonKey(name: 'swapused', fromJson: proxmoxInt) final  int? swapUsed;
@override@JsonKey(name: 'swaptotal', fromJson: proxmoxInt) final  int? swapTotal;
/// First value of Proxmox `loadavg` (1 minute).
@override@JsonKey(name: 'loadavg1m', fromJson: proxmoxDouble) final  double? loadavg1m;
/// CPU I/O wait when exposed by the node status payload.
@override@JsonKey(name: 'iowait', fromJson: proxmoxDouble) final  double? ioWait;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NodeCopyWith<_Node> get copyWith => __$NodeCopyWithImpl<_Node>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Node&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.maxCpu, maxCpu) || other.maxCpu == maxCpu)&&(identical(other.mem, mem) || other.mem == mem)&&(identical(other.maxMem, maxMem) || other.maxMem == maxMem)&&(identical(other.disk, disk) || other.disk == disk)&&(identical(other.maxDisk, maxDisk) || other.maxDisk == maxDisk)&&(identical(other.uptime, uptime) || other.uptime == uptime)&&(identical(other.sslFingerprint, sslFingerprint) || other.sslFingerprint == sslFingerprint)&&(identical(other.level, level) || other.level == level)&&(identical(other.swapUsed, swapUsed) || other.swapUsed == swapUsed)&&(identical(other.swapTotal, swapTotal) || other.swapTotal == swapTotal)&&(identical(other.loadavg1m, loadavg1m) || other.loadavg1m == loadavg1m)&&(identical(other.ioWait, ioWait) || other.ioWait == ioWait));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,status,cpu,maxCpu,mem,maxMem,disk,maxDisk,uptime,sslFingerprint,level,swapUsed,swapTotal,loadavg1m,ioWait);

@override
String toString() {
  return 'Node(name: $name, status: $status, cpu: $cpu, maxCpu: $maxCpu, mem: $mem, maxMem: $maxMem, disk: $disk, maxDisk: $maxDisk, uptime: $uptime, sslFingerprint: $sslFingerprint, level: $level, swapUsed: $swapUsed, swapTotal: $swapTotal, loadavg1m: $loadavg1m, ioWait: $ioWait)';
}


}

/// @nodoc
abstract mixin class _$NodeCopyWith<$Res> implements $NodeCopyWith<$Res> {
  factory _$NodeCopyWith(_Node value, $Res Function(_Node) _then) = __$NodeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'node') String name, String? status,@JsonKey(fromJson: proxmoxDouble) double? cpu,@JsonKey(name: 'maxcpu', fromJson: proxmoxInt) int? maxCpu,@JsonKey(fromJson: proxmoxInt) int? mem,@JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? maxMem,@JsonKey(fromJson: proxmoxInt) int? disk,@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? maxDisk,@JsonKey(fromJson: proxmoxInt) int? uptime,@JsonKey(name: 'ssl_fingerprint') String? sslFingerprint, String? level,@JsonKey(name: 'swapused', fromJson: proxmoxInt) int? swapUsed,@JsonKey(name: 'swaptotal', fromJson: proxmoxInt) int? swapTotal,@JsonKey(name: 'loadavg1m', fromJson: proxmoxDouble) double? loadavg1m,@JsonKey(name: 'iowait', fromJson: proxmoxDouble) double? ioWait
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = freezed,Object? cpu = freezed,Object? maxCpu = freezed,Object? mem = freezed,Object? maxMem = freezed,Object? disk = freezed,Object? maxDisk = freezed,Object? uptime = freezed,Object? sslFingerprint = freezed,Object? level = freezed,Object? swapUsed = freezed,Object? swapTotal = freezed,Object? loadavg1m = freezed,Object? ioWait = freezed,}) {
  return _then(_Node(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as double?,maxCpu: freezed == maxCpu ? _self.maxCpu : maxCpu // ignore: cast_nullable_to_non_nullable
as int?,mem: freezed == mem ? _self.mem : mem // ignore: cast_nullable_to_non_nullable
as int?,maxMem: freezed == maxMem ? _self.maxMem : maxMem // ignore: cast_nullable_to_non_nullable
as int?,disk: freezed == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int?,maxDisk: freezed == maxDisk ? _self.maxDisk : maxDisk // ignore: cast_nullable_to_non_nullable
as int?,uptime: freezed == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int?,sslFingerprint: freezed == sslFingerprint ? _self.sslFingerprint : sslFingerprint // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,swapUsed: freezed == swapUsed ? _self.swapUsed : swapUsed // ignore: cast_nullable_to_non_nullable
as int?,swapTotal: freezed == swapTotal ? _self.swapTotal : swapTotal // ignore: cast_nullable_to_non_nullable
as int?,loadavg1m: freezed == loadavg1m ? _self.loadavg1m : loadavg1m // ignore: cast_nullable_to_non_nullable
as double?,ioWait: freezed == ioWait ? _self.ioWait : ioWait // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
