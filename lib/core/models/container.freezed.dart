// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'container.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Container {

@JsonKey(fromJson: _ctidFromJson) int get vmid;@JsonKey(fromJson: _containerNameFromJson) String get name;@JsonKey(fromJson: _containerStatusFromJson, toJson: _containerStatusToJson) ContainerStatus get status; String get node;@JsonKey(fromJson: proxmoxDouble) double? get cpu;@JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? get maxMem;@JsonKey(fromJson: proxmoxInt) int? get mem;@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? get maxDisk;@JsonKey(fromJson: proxmoxInt) int? get disk;@JsonKey(fromJson: proxmoxInt) int? get uptime; String? get ostype;
/// Create a copy of Container
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContainerCopyWith<Container> get copyWith => _$ContainerCopyWithImpl<Container>(this as Container, _$identity);

  /// Serializes this Container to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Container&&(identical(other.vmid, vmid) || other.vmid == vmid)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.node, node) || other.node == node)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.maxMem, maxMem) || other.maxMem == maxMem)&&(identical(other.mem, mem) || other.mem == mem)&&(identical(other.maxDisk, maxDisk) || other.maxDisk == maxDisk)&&(identical(other.disk, disk) || other.disk == disk)&&(identical(other.uptime, uptime) || other.uptime == uptime)&&(identical(other.ostype, ostype) || other.ostype == ostype));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vmid,name,status,node,cpu,maxMem,mem,maxDisk,disk,uptime,ostype);

@override
String toString() {
  return 'Container(vmid: $vmid, name: $name, status: $status, node: $node, cpu: $cpu, maxMem: $maxMem, mem: $mem, maxDisk: $maxDisk, disk: $disk, uptime: $uptime, ostype: $ostype)';
}


}

/// @nodoc
abstract mixin class $ContainerCopyWith<$Res>  {
  factory $ContainerCopyWith(Container value, $Res Function(Container) _then) = _$ContainerCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _ctidFromJson) int vmid,@JsonKey(fromJson: _containerNameFromJson) String name,@JsonKey(fromJson: _containerStatusFromJson, toJson: _containerStatusToJson) ContainerStatus status, String node,@JsonKey(fromJson: proxmoxDouble) double? cpu,@JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? maxMem,@JsonKey(fromJson: proxmoxInt) int? mem,@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? maxDisk,@JsonKey(fromJson: proxmoxInt) int? disk,@JsonKey(fromJson: proxmoxInt) int? uptime, String? ostype
});




}
/// @nodoc
class _$ContainerCopyWithImpl<$Res>
    implements $ContainerCopyWith<$Res> {
  _$ContainerCopyWithImpl(this._self, this._then);

  final Container _self;
  final $Res Function(Container) _then;

/// Create a copy of Container
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vmid = null,Object? name = null,Object? status = null,Object? node = null,Object? cpu = freezed,Object? maxMem = freezed,Object? mem = freezed,Object? maxDisk = freezed,Object? disk = freezed,Object? uptime = freezed,Object? ostype = freezed,}) {
  return _then(_self.copyWith(
vmid: null == vmid ? _self.vmid : vmid // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContainerStatus,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as String,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as double?,maxMem: freezed == maxMem ? _self.maxMem : maxMem // ignore: cast_nullable_to_non_nullable
as int?,mem: freezed == mem ? _self.mem : mem // ignore: cast_nullable_to_non_nullable
as int?,maxDisk: freezed == maxDisk ? _self.maxDisk : maxDisk // ignore: cast_nullable_to_non_nullable
as int?,disk: freezed == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int?,uptime: freezed == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int?,ostype: freezed == ostype ? _self.ostype : ostype // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Container].
extension ContainerPatterns on Container {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Container value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Container() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Container value)  $default,){
final _that = this;
switch (_that) {
case _Container():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Container value)?  $default,){
final _that = this;
switch (_that) {
case _Container() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _ctidFromJson)  int vmid, @JsonKey(fromJson: _containerNameFromJson)  String name, @JsonKey(fromJson: _containerStatusFromJson, toJson: _containerStatusToJson)  ContainerStatus status,  String node, @JsonKey(fromJson: proxmoxDouble)  double? cpu, @JsonKey(name: 'maxmem', fromJson: proxmoxInt)  int? maxMem, @JsonKey(fromJson: proxmoxInt)  int? mem, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt)  int? maxDisk, @JsonKey(fromJson: proxmoxInt)  int? disk, @JsonKey(fromJson: proxmoxInt)  int? uptime,  String? ostype)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Container() when $default != null:
return $default(_that.vmid,_that.name,_that.status,_that.node,_that.cpu,_that.maxMem,_that.mem,_that.maxDisk,_that.disk,_that.uptime,_that.ostype);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _ctidFromJson)  int vmid, @JsonKey(fromJson: _containerNameFromJson)  String name, @JsonKey(fromJson: _containerStatusFromJson, toJson: _containerStatusToJson)  ContainerStatus status,  String node, @JsonKey(fromJson: proxmoxDouble)  double? cpu, @JsonKey(name: 'maxmem', fromJson: proxmoxInt)  int? maxMem, @JsonKey(fromJson: proxmoxInt)  int? mem, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt)  int? maxDisk, @JsonKey(fromJson: proxmoxInt)  int? disk, @JsonKey(fromJson: proxmoxInt)  int? uptime,  String? ostype)  $default,) {final _that = this;
switch (_that) {
case _Container():
return $default(_that.vmid,_that.name,_that.status,_that.node,_that.cpu,_that.maxMem,_that.mem,_that.maxDisk,_that.disk,_that.uptime,_that.ostype);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _ctidFromJson)  int vmid, @JsonKey(fromJson: _containerNameFromJson)  String name, @JsonKey(fromJson: _containerStatusFromJson, toJson: _containerStatusToJson)  ContainerStatus status,  String node, @JsonKey(fromJson: proxmoxDouble)  double? cpu, @JsonKey(name: 'maxmem', fromJson: proxmoxInt)  int? maxMem, @JsonKey(fromJson: proxmoxInt)  int? mem, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt)  int? maxDisk, @JsonKey(fromJson: proxmoxInt)  int? disk, @JsonKey(fromJson: proxmoxInt)  int? uptime,  String? ostype)?  $default,) {final _that = this;
switch (_that) {
case _Container() when $default != null:
return $default(_that.vmid,_that.name,_that.status,_that.node,_that.cpu,_that.maxMem,_that.mem,_that.maxDisk,_that.disk,_that.uptime,_that.ostype);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Container implements Container {
  const _Container({@JsonKey(fromJson: _ctidFromJson) required this.vmid, @JsonKey(fromJson: _containerNameFromJson) required this.name, @JsonKey(fromJson: _containerStatusFromJson, toJson: _containerStatusToJson) required this.status, required this.node, @JsonKey(fromJson: proxmoxDouble) this.cpu, @JsonKey(name: 'maxmem', fromJson: proxmoxInt) this.maxMem, @JsonKey(fromJson: proxmoxInt) this.mem, @JsonKey(name: 'maxdisk', fromJson: proxmoxInt) this.maxDisk, @JsonKey(fromJson: proxmoxInt) this.disk, @JsonKey(fromJson: proxmoxInt) this.uptime, this.ostype});
  factory _Container.fromJson(Map<String, dynamic> json) => _$ContainerFromJson(json);

@override@JsonKey(fromJson: _ctidFromJson) final  int vmid;
@override@JsonKey(fromJson: _containerNameFromJson) final  String name;
@override@JsonKey(fromJson: _containerStatusFromJson, toJson: _containerStatusToJson) final  ContainerStatus status;
@override final  String node;
@override@JsonKey(fromJson: proxmoxDouble) final  double? cpu;
@override@JsonKey(name: 'maxmem', fromJson: proxmoxInt) final  int? maxMem;
@override@JsonKey(fromJson: proxmoxInt) final  int? mem;
@override@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) final  int? maxDisk;
@override@JsonKey(fromJson: proxmoxInt) final  int? disk;
@override@JsonKey(fromJson: proxmoxInt) final  int? uptime;
@override final  String? ostype;

/// Create a copy of Container
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContainerCopyWith<_Container> get copyWith => __$ContainerCopyWithImpl<_Container>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContainerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Container&&(identical(other.vmid, vmid) || other.vmid == vmid)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.node, node) || other.node == node)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.maxMem, maxMem) || other.maxMem == maxMem)&&(identical(other.mem, mem) || other.mem == mem)&&(identical(other.maxDisk, maxDisk) || other.maxDisk == maxDisk)&&(identical(other.disk, disk) || other.disk == disk)&&(identical(other.uptime, uptime) || other.uptime == uptime)&&(identical(other.ostype, ostype) || other.ostype == ostype));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vmid,name,status,node,cpu,maxMem,mem,maxDisk,disk,uptime,ostype);

@override
String toString() {
  return 'Container(vmid: $vmid, name: $name, status: $status, node: $node, cpu: $cpu, maxMem: $maxMem, mem: $mem, maxDisk: $maxDisk, disk: $disk, uptime: $uptime, ostype: $ostype)';
}


}

/// @nodoc
abstract mixin class _$ContainerCopyWith<$Res> implements $ContainerCopyWith<$Res> {
  factory _$ContainerCopyWith(_Container value, $Res Function(_Container) _then) = __$ContainerCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _ctidFromJson) int vmid,@JsonKey(fromJson: _containerNameFromJson) String name,@JsonKey(fromJson: _containerStatusFromJson, toJson: _containerStatusToJson) ContainerStatus status, String node,@JsonKey(fromJson: proxmoxDouble) double? cpu,@JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? maxMem,@JsonKey(fromJson: proxmoxInt) int? mem,@JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? maxDisk,@JsonKey(fromJson: proxmoxInt) int? disk,@JsonKey(fromJson: proxmoxInt) int? uptime, String? ostype
});




}
/// @nodoc
class __$ContainerCopyWithImpl<$Res>
    implements _$ContainerCopyWith<$Res> {
  __$ContainerCopyWithImpl(this._self, this._then);

  final _Container _self;
  final $Res Function(_Container) _then;

/// Create a copy of Container
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vmid = null,Object? name = null,Object? status = null,Object? node = null,Object? cpu = freezed,Object? maxMem = freezed,Object? mem = freezed,Object? maxDisk = freezed,Object? disk = freezed,Object? uptime = freezed,Object? ostype = freezed,}) {
  return _then(_Container(
vmid: null == vmid ? _self.vmid : vmid // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContainerStatus,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as String,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as double?,maxMem: freezed == maxMem ? _self.maxMem : maxMem // ignore: cast_nullable_to_non_nullable
as int?,mem: freezed == mem ? _self.mem : mem // ignore: cast_nullable_to_non_nullable
as int?,maxDisk: freezed == maxDisk ? _self.maxDisk : maxDisk // ignore: cast_nullable_to_non_nullable
as int?,disk: freezed == disk ? _self.disk : disk // ignore: cast_nullable_to_non_nullable
as int?,uptime: freezed == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int?,ostype: freezed == ostype ? _self.ostype : ostype // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
