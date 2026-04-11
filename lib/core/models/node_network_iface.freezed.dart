// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node_network_iface.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NodeNetworkIface {

@JsonKey(fromJson: proxmoxString) String get iface;@JsonKey(fromJson: proxmoxString) String get type;
/// Create a copy of NodeNetworkIface
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NodeNetworkIfaceCopyWith<NodeNetworkIface> get copyWith => _$NodeNetworkIfaceCopyWithImpl<NodeNetworkIface>(this as NodeNetworkIface, _$identity);

  /// Serializes this NodeNetworkIface to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NodeNetworkIface&&(identical(other.iface, iface) || other.iface == iface)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,iface,type);

@override
String toString() {
  return 'NodeNetworkIface(iface: $iface, type: $type)';
}


}

/// @nodoc
abstract mixin class $NodeNetworkIfaceCopyWith<$Res>  {
  factory $NodeNetworkIfaceCopyWith(NodeNetworkIface value, $Res Function(NodeNetworkIface) _then) = _$NodeNetworkIfaceCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: proxmoxString) String iface,@JsonKey(fromJson: proxmoxString) String type
});




}
/// @nodoc
class _$NodeNetworkIfaceCopyWithImpl<$Res>
    implements $NodeNetworkIfaceCopyWith<$Res> {
  _$NodeNetworkIfaceCopyWithImpl(this._self, this._then);

  final NodeNetworkIface _self;
  final $Res Function(NodeNetworkIface) _then;

/// Create a copy of NodeNetworkIface
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? iface = null,Object? type = null,}) {
  return _then(_self.copyWith(
iface: null == iface ? _self.iface : iface // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NodeNetworkIface].
extension NodeNetworkIfacePatterns on NodeNetworkIface {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NodeNetworkIface value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NodeNetworkIface() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NodeNetworkIface value)  $default,){
final _that = this;
switch (_that) {
case _NodeNetworkIface():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NodeNetworkIface value)?  $default,){
final _that = this;
switch (_that) {
case _NodeNetworkIface() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: proxmoxString)  String iface, @JsonKey(fromJson: proxmoxString)  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NodeNetworkIface() when $default != null:
return $default(_that.iface,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: proxmoxString)  String iface, @JsonKey(fromJson: proxmoxString)  String type)  $default,) {final _that = this;
switch (_that) {
case _NodeNetworkIface():
return $default(_that.iface,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: proxmoxString)  String iface, @JsonKey(fromJson: proxmoxString)  String type)?  $default,) {final _that = this;
switch (_that) {
case _NodeNetworkIface() when $default != null:
return $default(_that.iface,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NodeNetworkIface extends NodeNetworkIface {
  const _NodeNetworkIface({@JsonKey(fromJson: proxmoxString) required this.iface, @JsonKey(fromJson: proxmoxString) this.type = ''}): super._();
  factory _NodeNetworkIface.fromJson(Map<String, dynamic> json) => _$NodeNetworkIfaceFromJson(json);

@override@JsonKey(fromJson: proxmoxString) final  String iface;
@override@JsonKey(fromJson: proxmoxString) final  String type;

/// Create a copy of NodeNetworkIface
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NodeNetworkIfaceCopyWith<_NodeNetworkIface> get copyWith => __$NodeNetworkIfaceCopyWithImpl<_NodeNetworkIface>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NodeNetworkIfaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NodeNetworkIface&&(identical(other.iface, iface) || other.iface == iface)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,iface,type);

@override
String toString() {
  return 'NodeNetworkIface(iface: $iface, type: $type)';
}


}

/// @nodoc
abstract mixin class _$NodeNetworkIfaceCopyWith<$Res> implements $NodeNetworkIfaceCopyWith<$Res> {
  factory _$NodeNetworkIfaceCopyWith(_NodeNetworkIface value, $Res Function(_NodeNetworkIface) _then) = __$NodeNetworkIfaceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: proxmoxString) String iface,@JsonKey(fromJson: proxmoxString) String type
});




}
/// @nodoc
class __$NodeNetworkIfaceCopyWithImpl<$Res>
    implements _$NodeNetworkIfaceCopyWith<$Res> {
  __$NodeNetworkIfaceCopyWithImpl(this._self, this._then);

  final _NodeNetworkIface _self;
  final $Res Function(_NodeNetworkIface) _then;

/// Create a copy of NodeNetworkIface
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? iface = null,Object? type = null,}) {
  return _then(_NodeNetworkIface(
iface: null == iface ? _self.iface : iface // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
