// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Vm {

@JsonKey(fromJson: _vmidFromJson) int get vmid;@JsonKey(fromJson: _vmNameFromJson) String get name;@JsonKey(fromJson: _vmStatusFromJson, toJson: _vmStatusToJson) VmStatus get status; String get node;@JsonKey(fromJson: proxmoxDouble) double? get cpu;@JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? get maxMem;@JsonKey(fromJson: proxmoxInt) int? get mem;@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? get maxDisk;@JsonKey(fromJson: proxmoxInt) int? get disk;@JsonKey(fromJson: proxmoxInt) int? get uptime;
/// Create a copy of Vm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VmCopyWith<Vm> get copyWith => _$VmCopyWithImpl<Vm>(this as Vm, _$identity);

  /// Serializes this Vm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vm&&(identical(other.vmid, vmid) || other.vmid == vmid)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.node, node) || other.node == node)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.maxMem, maxMem) || other.maxMem == maxMem)&&(identical(other.mem, mem) || other.mem == mem)&&(identical(other.maxDisk, maxDisk) || other.maxDisk == maxDisk)&&(identical(other.disk, disk) || other.disk == disk)&&(identical(other.uptime, uptime) || other.uptime == uptime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vmid,name,status,node,cpu,maxMem,mem,maxDisk,disk,uptime);

@override
String toString() {
  return 'Vm(vmid: $vmid, name: $name, status: $status, node: $node, cpu: $cpu, maxMem: $maxMem, mem: $mem, maxDisk: $maxDisk, disk: $disk, uptime: $uptime)';
}


}

/// @nodoc
abstract mixin class $VmCopyWith<$Res>  {
  factory $VmCopyWith(Vm value, $Res Function(Vm) _then) = _$VmCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _vmidFromJson) int vmid,@JsonKey(fromJson: _vmNameFromJson) String name,@JsonKey(fromJson: _vmStatusFromJson, toJson: _vmStatusToJson) VmStatus status, String node,@JsonKey(fromJson: proxmoxDouble) double? cpu,@JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? maxMem,@JsonKey(fromJson: proxmoxInt) int? mem,@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? maxDisk,@JsonKey(fromJson: proxmoxInt) int? disk,@JsonKey(fromJson: proxmoxInt) int? uptime
});




}
/// @nodoc
class _$VmCopyWithImpl<$Res>
    implements $VmCopyWith<$Res> {
  _$VmCopyWithImpl(this._self, this._then);

  final Vm _self;
  final $Res Function(Vm) _then;

/// Create a copy of Vm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vmid = null,Object? name = null,Object? status = null,Object? node = null,Object? cpu = freezed,Object? maxMem = freezed,Object? mem = freezed,Object? maxDisk = freezed,Object? disk = freezed,Object? uptime = freezed,}) {
  return _then(_self.copyWith(
vmid: null == vmid ? _self.vmid : vmid // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VmStatus,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as String,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as double?,maxMem: freezed == maxMem ? _self.maxMem : maxMem // ignore: cast_nullable_to_non_nullable
as int?,mem: freezed == mem ? _self.mem : mem // ignore: cast_nullable_to_non_nullable
as int?,maxDisk: freezed == maxDisk ? _self.maxDisk : maxDisk // ignore: cast_nullable_to_non_nullable
as int?,disk: freezed == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int?,uptime: freezed == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Vm].
extension VmPatterns on Vm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vm value)  $default,){
final _that = this;
switch (_that) {
case _Vm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vm value)?  $default,){
final _that = this;
switch (_that) {
case _Vm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _vmidFromJson)  int vmid, @JsonKey(fromJson: _vmNameFromJson)  String name, @JsonKey(fromJson: _vmStatusFromJson, toJson: _vmStatusToJson)  VmStatus status,  String node, @JsonKey(fromJson: proxmoxDouble)  double? cpu, @JsonKey(name: 'maxmem', fromJson: proxmoxInt)  int? maxMem, @JsonKey(fromJson: proxmoxInt)  int? mem, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt)  int? maxDisk, @JsonKey(fromJson: proxmoxInt)  int? disk, @JsonKey(fromJson: proxmoxInt)  int? uptime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vm() when $default != null:
return $default(_that.vmid,_that.name,_that.status,_that.node,_that.cpu,_that.maxMem,_that.mem,_that.maxDisk,_that.disk,_that.uptime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _vmidFromJson)  int vmid, @JsonKey(fromJson: _vmNameFromJson)  String name, @JsonKey(fromJson: _vmStatusFromJson, toJson: _vmStatusToJson)  VmStatus status,  String node, @JsonKey(fromJson: proxmoxDouble)  double? cpu, @JsonKey(name: 'maxmem', fromJson: proxmoxInt)  int? maxMem, @JsonKey(fromJson: proxmoxInt)  int? mem, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt)  int? maxDisk, @JsonKey(fromJson: proxmoxInt)  int? disk, @JsonKey(fromJson: proxmoxInt)  int? uptime)  $default,) {final _that = this;
switch (_that) {
case _Vm():
return $default(_that.vmid,_that.name,_that.status,_that.node,_that.cpu,_that.maxMem,_that.mem,_that.maxDisk,_that.disk,_that.uptime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _vmidFromJson)  int vmid, @JsonKey(fromJson: _vmNameFromJson)  String name, @JsonKey(fromJson: _vmStatusFromJson, toJson: _vmStatusToJson)  VmStatus status,  String node, @JsonKey(fromJson: proxmoxDouble)  double? cpu, @JsonKey(name: 'maxmem', fromJson: proxmoxInt)  int? maxMem, @JsonKey(fromJson: proxmoxInt)  int? mem, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt)  int? maxDisk, @JsonKey(fromJson: proxmoxInt)  int? disk, @JsonKey(fromJson: proxmoxInt)  int? uptime)?  $default,) {final _that = this;
switch (_that) {
case _Vm() when $default != null:
return $default(_that.vmid,_that.name,_that.status,_that.node,_that.cpu,_that.maxMem,_that.mem,_that.maxDisk,_that.disk,_that.uptime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vm implements Vm {
  const _Vm({@JsonKey(fromJson: _vmidFromJson) required this.vmid, @JsonKey(fromJson: _vmNameFromJson) required this.name, @JsonKey(fromJson: _vmStatusFromJson, toJson: _vmStatusToJson) required this.status, required this.node, @JsonKey(fromJson: proxmoxDouble) this.cpu, @JsonKey(name: 'maxmem', fromJson: proxmoxInt) this.maxMem, @JsonKey(fromJson: proxmoxInt) this.mem, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt) this.maxDisk, @JsonKey(fromJson: proxmoxInt) this.disk, @JsonKey(fromJson: proxmoxInt) this.uptime});
  factory _Vm.fromJson(Map<String, dynamic> json) => _$VmFromJson(json);

@override@JsonKey(fromJson: _vmidFromJson) final  int vmid;
@override@JsonKey(fromJson: _vmNameFromJson) final  String name;
@override@JsonKey(fromJson: _vmStatusFromJson, toJson: _vmStatusToJson) final  VmStatus status;
@override final  String node;
@override@JsonKey(fromJson: proxmoxDouble) final  double? cpu;
@override@JsonKey(name: 'maxmem', fromJson: proxmoxInt) final  int? maxMem;
@override@JsonKey(fromJson: proxmoxInt) final  int? mem;
@override@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) final  int? maxDisk;
@override@JsonKey(fromJson: proxmoxInt) final  int? disk;
@override@JsonKey(fromJson: proxmoxInt) final  int? uptime;

/// Create a copy of Vm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VmCopyWith<_Vm> get copyWith => __$VmCopyWithImpl<_Vm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VmToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vm&&(identical(other.vmid, vmid) || other.vmid == vmid)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.node, node) || other.node == node)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.maxMem, maxMem) || other.maxMem == maxMem)&&(identical(other.mem, mem) || other.mem == mem)&&(identical(other.maxDisk, maxDisk) || other.maxDisk == maxDisk)&&(identical(other.disk, disk) || other.disk == disk)&&(identical(other.uptime, uptime) || other.uptime == uptime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vmid,name,status,node,cpu,maxMem,mem,maxDisk,disk,uptime);

@override
String toString() {
  return 'Vm(vmid: $vmid, name: $name, status: $status, node: $node, cpu: $cpu, maxMem: $maxMem, mem: $mem, maxDisk: $maxDisk, disk: $disk, uptime: $uptime)';
}


}

/// @nodoc
abstract mixin class _$VmCopyWith<$Res> implements $VmCopyWith<$Res> {
  factory _$VmCopyWith(_Vm value, $Res Function(_Vm) _then) = __$VmCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _vmidFromJson) int vmid,@JsonKey(fromJson: _vmNameFromJson) String name,@JsonKey(fromJson: _vmStatusFromJson, toJson: _vmStatusToJson) VmStatus status, String node,@JsonKey(fromJson: proxmoxDouble) double? cpu,@JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? maxMem,@JsonKey(fromJson: proxmoxInt) int? mem,@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? maxDisk,@JsonKey(fromJson: proxmoxInt) int? disk,@JsonKey(fromJson: proxmoxInt) int? uptime
});




}
/// @nodoc
class __$VmCopyWithImpl<$Res>
    implements _$VmCopyWith<$Res> {
  __$VmCopyWithImpl(this._self, this._then);

  final _Vm _self;
  final $Res Function(_Vm) _then;

/// Create a copy of Vm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vmid = null,Object? name = null,Object? status = null,Object? node = null,Object? cpu = freezed,Object? maxMem = freezed,Object? mem = freezed,Object? maxDisk = freezed,Object? disk = freezed,Object? uptime = freezed,}) {
  return _then(_Vm(
vmid: null == vmid ? _self.vmid : vmid // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VmStatus,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as String,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as double?,maxMem: freezed == maxMem ? _self.maxMem : maxMem // ignore: cast_nullable_to_non_nullable
as int?,mem: freezed == mem ? _self.mem : mem // ignore: cast_nullable_to_non_nullable
as int?,maxDisk: freezed == maxDisk ? _self.maxDisk : maxDisk // ignore: cast_nullable_to_non_nullable
as int?,disk: freezed == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int?,uptime: freezed == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
