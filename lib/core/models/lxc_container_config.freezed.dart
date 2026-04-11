// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lxc_container_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LxcContainerConfig {

 String? get hostname; String? get description; String? get tags; String? get memory; String? get swap; String? get cores; String? get cpulimit; String? get cpuunits; String? get ostype; String? get arch; String? get onboot; String? get startup; String? get unprivileged; String? get features; String? get rootfs;@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> get netLines;@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> get mpLines; Map<String, String> get passthrough;
/// Create a copy of LxcContainerConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LxcContainerConfigCopyWith<LxcContainerConfig> get copyWith => _$LxcContainerConfigCopyWithImpl<LxcContainerConfig>(this as LxcContainerConfig, _$identity);

  /// Serializes this LxcContainerConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LxcContainerConfig&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.description, description) || other.description == description)&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.swap, swap) || other.swap == swap)&&(identical(other.cores, cores) || other.cores == cores)&&(identical(other.cpulimit, cpulimit) || other.cpulimit == cpulimit)&&(identical(other.cpuunits, cpuunits) || other.cpuunits == cpuunits)&&(identical(other.ostype, ostype) || other.ostype == ostype)&&(identical(other.arch, arch) || other.arch == arch)&&(identical(other.onboot, onboot) || other.onboot == onboot)&&(identical(other.startup, startup) || other.startup == startup)&&(identical(other.unprivileged, unprivileged) || other.unprivileged == unprivileged)&&(identical(other.features, features) || other.features == features)&&(identical(other.rootfs, rootfs) || other.rootfs == rootfs)&&const DeepCollectionEquality().equals(other.netLines, netLines)&&const DeepCollectionEquality().equals(other.mpLines, mpLines)&&const DeepCollectionEquality().equals(other.passthrough, passthrough));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostname,description,tags,memory,swap,cores,cpulimit,cpuunits,ostype,arch,onboot,startup,unprivileged,features,rootfs,const DeepCollectionEquality().hash(netLines),const DeepCollectionEquality().hash(mpLines),const DeepCollectionEquality().hash(passthrough));

@override
String toString() {
  return 'LxcContainerConfig(hostname: $hostname, description: $description, tags: $tags, memory: $memory, swap: $swap, cores: $cores, cpulimit: $cpulimit, cpuunits: $cpuunits, ostype: $ostype, arch: $arch, onboot: $onboot, startup: $startup, unprivileged: $unprivileged, features: $features, rootfs: $rootfs, netLines: $netLines, mpLines: $mpLines, passthrough: $passthrough)';
}


}

/// @nodoc
abstract mixin class $LxcContainerConfigCopyWith<$Res>  {
  factory $LxcContainerConfigCopyWith(LxcContainerConfig value, $Res Function(LxcContainerConfig) _then) = _$LxcContainerConfigCopyWithImpl;
@useResult
$Res call({
 String? hostname, String? description, String? tags, String? memory, String? swap, String? cores, String? cpulimit, String? cpuunits, String? ostype, String? arch, String? onboot, String? startup, String? unprivileged, String? features, String? rootfs,@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> netLines,@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> mpLines, Map<String, String> passthrough
});




}
/// @nodoc
class _$LxcContainerConfigCopyWithImpl<$Res>
    implements $LxcContainerConfigCopyWith<$Res> {
  _$LxcContainerConfigCopyWithImpl(this._self, this._then);

  final LxcContainerConfig _self;
  final $Res Function(LxcContainerConfig) _then;

/// Create a copy of LxcContainerConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostname = freezed,Object? description = freezed,Object? tags = freezed,Object? memory = freezed,Object? swap = freezed,Object? cores = freezed,Object? cpulimit = freezed,Object? cpuunits = freezed,Object? ostype = freezed,Object? arch = freezed,Object? onboot = freezed,Object? startup = freezed,Object? unprivileged = freezed,Object? features = freezed,Object? rootfs = freezed,Object? netLines = null,Object? mpLines = null,Object? passthrough = null,}) {
  return _then(_self.copyWith(
hostname: freezed == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String?,memory: freezed == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as String?,swap: freezed == swap ? _self.swap : swap // ignore: cast_nullable_to_non_nullable
as String?,cores: freezed == cores ? _self.cores : cores // ignore: cast_nullable_to_non_nullable
as String?,cpulimit: freezed == cpulimit ? _self.cpulimit : cpulimit // ignore: cast_nullable_to_non_nullable
as String?,cpuunits: freezed == cpuunits ? _self.cpuunits : cpuunits // ignore: cast_nullable_to_non_nullable
as String?,ostype: freezed == ostype ? _self.ostype : ostype // ignore: cast_nullable_to_non_nullable
as String?,arch: freezed == arch ? _self.arch : arch // ignore: cast_nullable_to_non_nullable
as String?,onboot: freezed == onboot ? _self.onboot : onboot // ignore: cast_nullable_to_non_nullable
as String?,startup: freezed == startup ? _self.startup : startup // ignore: cast_nullable_to_non_nullable
as String?,unprivileged: freezed == unprivileged ? _self.unprivileged : unprivileged // ignore: cast_nullable_to_non_nullable
as String?,features: freezed == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as String?,rootfs: freezed == rootfs ? _self.rootfs : rootfs // ignore: cast_nullable_to_non_nullable
as String?,netLines: null == netLines ? _self.netLines : netLines // ignore: cast_nullable_to_non_nullable
as List<GuestConfigIndexedLine>,mpLines: null == mpLines ? _self.mpLines : mpLines // ignore: cast_nullable_to_non_nullable
as List<GuestConfigIndexedLine>,passthrough: null == passthrough ? _self.passthrough : passthrough // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LxcContainerConfig].
extension LxcContainerConfigPatterns on LxcContainerConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LxcContainerConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LxcContainerConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LxcContainerConfig value)  $default,){
final _that = this;
switch (_that) {
case _LxcContainerConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LxcContainerConfig value)?  $default,){
final _that = this;
switch (_that) {
case _LxcContainerConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? hostname,  String? description,  String? tags,  String? memory,  String? swap,  String? cores,  String? cpulimit,  String? cpuunits,  String? ostype,  String? arch,  String? onboot,  String? startup,  String? unprivileged,  String? features,  String? rootfs, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> netLines, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> mpLines,  Map<String, String> passthrough)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LxcContainerConfig() when $default != null:
return $default(_that.hostname,_that.description,_that.tags,_that.memory,_that.swap,_that.cores,_that.cpulimit,_that.cpuunits,_that.ostype,_that.arch,_that.onboot,_that.startup,_that.unprivileged,_that.features,_that.rootfs,_that.netLines,_that.mpLines,_that.passthrough);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? hostname,  String? description,  String? tags,  String? memory,  String? swap,  String? cores,  String? cpulimit,  String? cpuunits,  String? ostype,  String? arch,  String? onboot,  String? startup,  String? unprivileged,  String? features,  String? rootfs, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> netLines, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> mpLines,  Map<String, String> passthrough)  $default,) {final _that = this;
switch (_that) {
case _LxcContainerConfig():
return $default(_that.hostname,_that.description,_that.tags,_that.memory,_that.swap,_that.cores,_that.cpulimit,_that.cpuunits,_that.ostype,_that.arch,_that.onboot,_that.startup,_that.unprivileged,_that.features,_that.rootfs,_that.netLines,_that.mpLines,_that.passthrough);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? hostname,  String? description,  String? tags,  String? memory,  String? swap,  String? cores,  String? cpulimit,  String? cpuunits,  String? ostype,  String? arch,  String? onboot,  String? startup,  String? unprivileged,  String? features,  String? rootfs, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> netLines, @JsonKey(includeFromJson: false, includeToJson: false)  List<GuestConfigIndexedLine> mpLines,  Map<String, String> passthrough)?  $default,) {final _that = this;
switch (_that) {
case _LxcContainerConfig() when $default != null:
return $default(_that.hostname,_that.description,_that.tags,_that.memory,_that.swap,_that.cores,_that.cpulimit,_that.cpuunits,_that.ostype,_that.arch,_that.onboot,_that.startup,_that.unprivileged,_that.features,_that.rootfs,_that.netLines,_that.mpLines,_that.passthrough);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LxcContainerConfig extends LxcContainerConfig {
  const _LxcContainerConfig({this.hostname, this.description, this.tags, this.memory, this.swap, this.cores, this.cpulimit, this.cpuunits, this.ostype, this.arch, this.onboot, this.startup, this.unprivileged, this.features, this.rootfs, @JsonKey(includeFromJson: false, includeToJson: false) final  List<GuestConfigIndexedLine> netLines = const [], @JsonKey(includeFromJson: false, includeToJson: false) final  List<GuestConfigIndexedLine> mpLines = const [], final  Map<String, String> passthrough = const {}}): _netLines = netLines,_mpLines = mpLines,_passthrough = passthrough,super._();
  factory _LxcContainerConfig.fromJson(Map<String, dynamic> json) => _$LxcContainerConfigFromJson(json);

@override final  String? hostname;
@override final  String? description;
@override final  String? tags;
@override final  String? memory;
@override final  String? swap;
@override final  String? cores;
@override final  String? cpulimit;
@override final  String? cpuunits;
@override final  String? ostype;
@override final  String? arch;
@override final  String? onboot;
@override final  String? startup;
@override final  String? unprivileged;
@override final  String? features;
@override final  String? rootfs;
 final  List<GuestConfigIndexedLine> _netLines;
@override@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> get netLines {
  if (_netLines is EqualUnmodifiableListView) return _netLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_netLines);
}

 final  List<GuestConfigIndexedLine> _mpLines;
@override@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> get mpLines {
  if (_mpLines is EqualUnmodifiableListView) return _mpLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mpLines);
}

 final  Map<String, String> _passthrough;
@override@JsonKey() Map<String, String> get passthrough {
  if (_passthrough is EqualUnmodifiableMapView) return _passthrough;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_passthrough);
}


/// Create a copy of LxcContainerConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LxcContainerConfigCopyWith<_LxcContainerConfig> get copyWith => __$LxcContainerConfigCopyWithImpl<_LxcContainerConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LxcContainerConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LxcContainerConfig&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.description, description) || other.description == description)&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.swap, swap) || other.swap == swap)&&(identical(other.cores, cores) || other.cores == cores)&&(identical(other.cpulimit, cpulimit) || other.cpulimit == cpulimit)&&(identical(other.cpuunits, cpuunits) || other.cpuunits == cpuunits)&&(identical(other.ostype, ostype) || other.ostype == ostype)&&(identical(other.arch, arch) || other.arch == arch)&&(identical(other.onboot, onboot) || other.onboot == onboot)&&(identical(other.startup, startup) || other.startup == startup)&&(identical(other.unprivileged, unprivileged) || other.unprivileged == unprivileged)&&(identical(other.features, features) || other.features == features)&&(identical(other.rootfs, rootfs) || other.rootfs == rootfs)&&const DeepCollectionEquality().equals(other._netLines, _netLines)&&const DeepCollectionEquality().equals(other._mpLines, _mpLines)&&const DeepCollectionEquality().equals(other._passthrough, _passthrough));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostname,description,tags,memory,swap,cores,cpulimit,cpuunits,ostype,arch,onboot,startup,unprivileged,features,rootfs,const DeepCollectionEquality().hash(_netLines),const DeepCollectionEquality().hash(_mpLines),const DeepCollectionEquality().hash(_passthrough));

@override
String toString() {
  return 'LxcContainerConfig(hostname: $hostname, description: $description, tags: $tags, memory: $memory, swap: $swap, cores: $cores, cpulimit: $cpulimit, cpuunits: $cpuunits, ostype: $ostype, arch: $arch, onboot: $onboot, startup: $startup, unprivileged: $unprivileged, features: $features, rootfs: $rootfs, netLines: $netLines, mpLines: $mpLines, passthrough: $passthrough)';
}


}

/// @nodoc
abstract mixin class _$LxcContainerConfigCopyWith<$Res> implements $LxcContainerConfigCopyWith<$Res> {
  factory _$LxcContainerConfigCopyWith(_LxcContainerConfig value, $Res Function(_LxcContainerConfig) _then) = __$LxcContainerConfigCopyWithImpl;
@override @useResult
$Res call({
 String? hostname, String? description, String? tags, String? memory, String? swap, String? cores, String? cpulimit, String? cpuunits, String? ostype, String? arch, String? onboot, String? startup, String? unprivileged, String? features, String? rootfs,@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> netLines,@JsonKey(includeFromJson: false, includeToJson: false) List<GuestConfigIndexedLine> mpLines, Map<String, String> passthrough
});




}
/// @nodoc
class __$LxcContainerConfigCopyWithImpl<$Res>
    implements _$LxcContainerConfigCopyWith<$Res> {
  __$LxcContainerConfigCopyWithImpl(this._self, this._then);

  final _LxcContainerConfig _self;
  final $Res Function(_LxcContainerConfig) _then;

/// Create a copy of LxcContainerConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostname = freezed,Object? description = freezed,Object? tags = freezed,Object? memory = freezed,Object? swap = freezed,Object? cores = freezed,Object? cpulimit = freezed,Object? cpuunits = freezed,Object? ostype = freezed,Object? arch = freezed,Object? onboot = freezed,Object? startup = freezed,Object? unprivileged = freezed,Object? features = freezed,Object? rootfs = freezed,Object? netLines = null,Object? mpLines = null,Object? passthrough = null,}) {
  return _then(_LxcContainerConfig(
hostname: freezed == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String?,memory: freezed == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as String?,swap: freezed == swap ? _self.swap : swap // ignore: cast_nullable_to_non_nullable
as String?,cores: freezed == cores ? _self.cores : cores // ignore: cast_nullable_to_non_nullable
as String?,cpulimit: freezed == cpulimit ? _self.cpulimit : cpulimit // ignore: cast_nullable_to_non_nullable
as String?,cpuunits: freezed == cpuunits ? _self.cpuunits : cpuunits // ignore: cast_nullable_to_non_nullable
as String?,ostype: freezed == ostype ? _self.ostype : ostype // ignore: cast_nullable_to_non_nullable
as String?,arch: freezed == arch ? _self.arch : arch // ignore: cast_nullable_to_non_nullable
as String?,onboot: freezed == onboot ? _self.onboot : onboot // ignore: cast_nullable_to_non_nullable
as String?,startup: freezed == startup ? _self.startup : startup // ignore: cast_nullable_to_non_nullable
as String?,unprivileged: freezed == unprivileged ? _self.unprivileged : unprivileged // ignore: cast_nullable_to_non_nullable
as String?,features: freezed == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as String?,rootfs: freezed == rootfs ? _self.rootfs : rootfs // ignore: cast_nullable_to_non_nullable
as String?,netLines: null == netLines ? _self._netLines : netLines // ignore: cast_nullable_to_non_nullable
as List<GuestConfigIndexedLine>,mpLines: null == mpLines ? _self._mpLines : mpLines // ignore: cast_nullable_to_non_nullable
as List<GuestConfigIndexedLine>,passthrough: null == passthrough ? _self._passthrough : passthrough // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
