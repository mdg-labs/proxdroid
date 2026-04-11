// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qemu_vm_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QemuVmConfig {

 String? get name; String? get description; String? get tags; String? get memory; String? get sockets; String? get cores; String? get vcpus; String? get cpu; String? get ostype; String? get onboot; String? get startup; String? get agent;@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> get netLines;@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> get diskLines; Map<String, String> get passthrough;
/// Create a copy of QemuVmConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QemuVmConfigCopyWith<QemuVmConfig> get copyWith => _$QemuVmConfigCopyWithImpl<QemuVmConfig>(this as QemuVmConfig, _$identity);

  /// Serializes this QemuVmConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QemuVmConfig&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.sockets, sockets) || other.sockets == sockets)&&(identical(other.cores, cores) || other.cores == cores)&&(identical(other.vcpus, vcpus) || other.vcpus == vcpus)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.ostype, ostype) || other.ostype == ostype)&&(identical(other.onboot, onboot) || other.onboot == onboot)&&(identical(other.startup, startup) || other.startup == startup)&&(identical(other.agent, agent) || other.agent == agent)&&const DeepCollectionEquality().equals(other.netLines, netLines)&&const DeepCollectionEquality().equals(other.diskLines, diskLines)&&const DeepCollectionEquality().equals(other.passthrough, passthrough));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,tags,memory,sockets,cores,vcpus,cpu,ostype,onboot,startup,agent,const DeepCollectionEquality().hash(netLines),const DeepCollectionEquality().hash(diskLines),const DeepCollectionEquality().hash(passthrough));

@override
String toString() {
  return 'QemuVmConfig(name: $name, description: $description, tags: $tags, memory: $memory, sockets: $sockets, cores: $cores, vcpus: $vcpus, cpu: $cpu, ostype: $ostype, onboot: $onboot, startup: $startup, agent: $agent, netLines: $netLines, diskLines: $diskLines, passthrough: $passthrough)';
}


}

/// @nodoc
abstract mixin class $QemuVmConfigCopyWith<$Res>  {
  factory $QemuVmConfigCopyWith(QemuVmConfig value, $Res Function(QemuVmConfig) _then) = _$QemuVmConfigCopyWithImpl;
@useResult
$Res call({
 String? name, String? description, String? tags, String? memory, String? sockets, String? cores, String? vcpus, String? cpu, String? ostype, String? onboot, String? startup, String? agent,@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> netLines,@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> diskLines, Map<String, String> passthrough
});




}
/// @nodoc
class _$QemuVmConfigCopyWithImpl<$Res>
    implements $QemuVmConfigCopyWith<$Res> {
  _$QemuVmConfigCopyWithImpl(this._self, this._then);

  final QemuVmConfig _self;
  final $Res Function(QemuVmConfig) _then;

/// Create a copy of QemuVmConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? description = freezed,Object? tags = freezed,Object? memory = freezed,Object? sockets = freezed,Object? cores = freezed,Object? vcpus = freezed,Object? cpu = freezed,Object? ostype = freezed,Object? onboot = freezed,Object? startup = freezed,Object? agent = freezed,Object? netLines = null,Object? diskLines = null,Object? passthrough = null,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String?,memory: freezed == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as String?,sockets: freezed == sockets ? _self.sockets : sockets // ignore: cast_nullable_to_non_nullable
as String?,cores: freezed == cores ? _self.cores : cores // ignore: cast_nullable_to_non_nullable
as String?,vcpus: freezed == vcpus ? _self.vcpus : vcpus // ignore: cast_nullable_to_non_nullable
as String?,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as String?,ostype: freezed == ostype ? _self.ostype : ostype // ignore: cast_nullable_to_non_nullable
as String?,onboot: freezed == onboot ? _self.onboot : onboot // ignore: cast_nullable_to_non_nullable
as String?,startup: freezed == startup ? _self.startup : startup // ignore: cast_nullable_to_non_nullable
as String?,agent: freezed == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String?,netLines: null == netLines ? _self.netLines : netLines // ignore: cast_nullable_to_non_nullable
as List<GuestConfigIndexedLine>,diskLines: null == diskLines ? _self.diskLines : diskLines // ignore: cast_nullable_to_non_nullable
as List<GuestConfigIndexedLine>,passthrough: null == passthrough ? _self.passthrough : passthrough // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [QemuVmConfig].
extension QemuVmConfigPatterns on QemuVmConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QemuVmConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QemuVmConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QemuVmConfig value)  $default,){
final _that = this;
switch (_that) {
case _QemuVmConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QemuVmConfig value)?  $default,){
final _that = this;
switch (_that) {
case _QemuVmConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? description,  String? tags,  String? memory,  String? sockets,  String? cores,  String? vcpus,  String? cpu,  String? ostype,  String? onboot,  String? startup,  String? agent, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> netLines, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> diskLines,  Map<String, String> passthrough)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QemuVmConfig() when $default != null:
return $default(_that.name,_that.description,_that.tags,_that.memory,_that.sockets,_that.cores,_that.vcpus,_that.cpu,_that.ostype,_that.onboot,_that.startup,_that.agent,_that.netLines,_that.diskLines,_that.passthrough);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? description,  String? tags,  String? memory,  String? sockets,  String? cores,  String? vcpus,  String? cpu,  String? ostype,  String? onboot,  String? startup,  String? agent, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> netLines, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> diskLines,  Map<String, String> passthrough)  $default,) {final _that = this;
switch (_that) {
case _QemuVmConfig():
return $default(_that.name,_that.description,_that.tags,_that.memory,_that.sockets,_that.cores,_that.vcpus,_that.cpu,_that.ostype,_that.onboot,_that.startup,_that.agent,_that.netLines,_that.diskLines,_that.passthrough);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? description,  String? tags,  String? memory,  String? sockets,  String? cores,  String? vcpus,  String? cpu,  String? ostype,  String? onboot,  String? startup,  String? agent, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> netLines, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> diskLines,  Map<String, String> passthrough)?  $default,) {final _that = this;
switch (_that) {
case _QemuVmConfig() when $default != null:
return $default(_that.name,_that.description,_that.tags,_that.memory,_that.sockets,_that.cores,_that.vcpus,_that.cpu,_that.ostype,_that.onboot,_that.startup,_that.agent,_that.netLines,_that.diskLines,_that.passthrough);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QemuVmConfig extends QemuVmConfig {
  const _QemuVmConfig({this.name, this.description, this.tags, this.memory, this.sockets, this.cores, this.vcpus, this.cpu, this.ostype, this.onboot, this.startup, this.agent, @JsonKey(includeFromJson: false, includeToJson: false) final  List<GuestConfigIndexedLine> netLines = const [], @JsonKey(includeFromJson: false, includeToJson: false) final  List<GuestConfigIndexedLine> diskLines = const [], final  Map<String, String> passthrough = const {}}): _netLines = netLines,_diskLines = diskLines,_passthrough = passthrough,super._();
  factory _QemuVmConfig.fromJson(Map<String, dynamic> json) => _$QemuVmConfigFromJson(json);

@override final  String? name;
@override final  String? description;
@override final  String? tags;
@override final  String? memory;
@override final  String? sockets;
@override final  String? cores;
@override final  String? vcpus;
@override final  String? cpu;
@override final  String? ostype;
@override final  String? onboot;
@override final  String? startup;
@override final  String? agent;
 final  List<GuestConfigIndexedLine> _netLines;
@override@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> get netLines {
  if (_netLines is EqualUnmodifiableListView) return _netLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_netLines);
}

 final  List<GuestConfigIndexedLine> _diskLines;
@override@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> get diskLines {
  if (_diskLines is EqualUnmodifiableListView) return _diskLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_diskLines);
}

 final  Map<String, String> _passthrough;
@override@JsonKey() Map<String, String> get passthrough {
  if (_passthrough is EqualUnmodifiableMapView) return _passthrough;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_passthrough);
}


/// Create a copy of QemuVmConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QemuVmConfigCopyWith<_QemuVmConfig> get copyWith => __$QemuVmConfigCopyWithImpl<_QemuVmConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QemuVmConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QemuVmConfig&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.sockets, sockets) || other.sockets == sockets)&&(identical(other.cores, cores) || other.cores == cores)&&(identical(other.vcpus, vcpus) || other.vcpus == vcpus)&&(identical(other.cpu, cpu) || other.cpu == cpu)&&(identical(other.ostype, ostype) || other.ostype == ostype)&&(identical(other.onboot, onboot) || other.onboot == onboot)&&(identical(other.startup, startup) || other.startup == startup)&&(identical(other.agent, agent) || other.agent == agent)&&const DeepCollectionEquality().equals(other._netLines, _netLines)&&const DeepCollectionEquality().equals(other._diskLines, _diskLines)&&const DeepCollectionEquality().equals(other._passthrough, _passthrough));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,tags,memory,sockets,cores,vcpus,cpu,ostype,onboot,startup,agent,const DeepCollectionEquality().hash(_netLines),const DeepCollectionEquality().hash(_diskLines),const DeepCollectionEquality().hash(_passthrough));

@override
String toString() {
  return 'QemuVmConfig(name: $name, description: $description, tags: $tags, memory: $memory, sockets: $sockets, cores: $cores, vcpus: $vcpus, cpu: $cpu, ostype: $ostype, onboot: $onboot, startup: $startup, agent: $agent, netLines: $netLines, diskLines: $diskLines, passthrough: $passthrough)';
}


}

/// @nodoc
abstract mixin class _$QemuVmConfigCopyWith<$Res> implements $QemuVmConfigCopyWith<$Res> {
  factory _$QemuVmConfigCopyWith(_QemuVmConfig value, $Res Function(_QemuVmConfig) _then) = __$QemuVmConfigCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? description, String? tags, String? memory, String? sockets, String? cores, String? vcpus, String? cpu, String? ostype, String? onboot, String? startup, String? agent,@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> netLines,@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> diskLines, Map<String, String> passthrough
});




}
/// @nodoc
class __$QemuVmConfigCopyWithImpl<$Res>
    implements _$QemuVmConfigCopyWith<$Res> {
  __$QemuVmConfigCopyWithImpl(this._self, this._then);

  final _QemuVmConfig _self;
  final $Res Function(_QemuVmConfig) _then;

/// Create a copy of QemuVmConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? description = freezed,Object? tags = freezed,Object? memory = freezed,Object? sockets = freezed,Object? cores = freezed,Object? vcpus = freezed,Object? cpu = freezed,Object? ostype = freezed,Object? onboot = freezed,Object? startup = freezed,Object? agent = freezed,Object? netLines = null,Object? diskLines = null,Object? passthrough = null,}) {
  return _then(_QemuVmConfig(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String?,memory: freezed == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as String?,sockets: freezed == sockets ? _self.sockets : sockets // ignore: cast_nullable_to_non_nullable
as String?,cores: freezed == cores ? _self.cores : cores // ignore: cast_nullable_to_non_nullable
as String?,vcpus: freezed == vcpus ? _self.vcpus : vcpus // ignore: cast_nullable_to_non_nullable
as String?,cpu: freezed == cpu ? _self.cpu : cpu // ignore: cast_nullable_to_non_nullable
as String?,ostype: freezed == ostype ? _self.ostype : ostype // ignore: cast_nullable_to_non_nullable
as String?,onboot: freezed == onboot ? _self.onboot : onboot // ignore: cast_nullable_to_non_nullable
as String?,startup: freezed == startup ? _self.startup : startup // ignore: cast_nullable_to_non_nullable
as String?,agent: freezed == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String?,netLines: null == netLines ? _self._netLines : netLines // ignore: cast_nullable_to_non_nullable
as List<GuestConfigIndexedLine>,diskLines: null == diskLines ? _self._diskLines : diskLines // ignore: cast_nullable_to_non_nullable
as List<GuestConfigIndexedLine>,passthrough: null == passthrough ? _self._passthrough : passthrough // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
