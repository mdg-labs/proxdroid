// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Storage {

/// Pool id (`storage` in PVE JSON).
@JsonKey(name: 'storage') String get id; String get node;@JsonKey(fromJson: proxmoxString) String get type;@JsonKey(name: 'content', fromJson: storageContentKindsFromJson) List<String> get content;@JsonKey(fromJson: proxmoxInt) int? get total;@JsonKey(fromJson: proxmoxInt) int? get used;@JsonKey(name: 'avail', fromJson: proxmoxInt) int? get available;@JsonKey(fromJson: storageActiveFromJson) bool get active;
/// Create a copy of Storage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageCopyWith<Storage> get copyWith => _$StorageCopyWithImpl<Storage>(this as Storage, _$identity);

  /// Serializes this Storage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Storage&&(identical(other.id, id) || other.id == id)&&(identical(other.node, node) || other.node == node)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.total, total) || other.total == total)&&(identical(other.used, used) || other.used == used)&&(identical(other.available, available) || other.available == available)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,node,type,const DeepCollectionEquality().hash(content),total,used,available,active);

@override
String toString() {
  return 'Storage(id: $id, node: $node, type: $type, content: $content, total: $total, used: $used, available: $available, active: $active)';
}


}

/// @nodoc
abstract mixin class $StorageCopyWith<$Res>  {
  factory $StorageCopyWith(Storage value, $Res Function(Storage) _then) = _$StorageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'storage') String id, String node,@JsonKey(fromJson: proxmoxString) String type,@JsonKey(name: 'content', fromJson: storageContentKindsFromJson) List<String> content,@JsonKey(fromJson: proxmoxInt) int? total,@JsonKey(fromJson: proxmoxInt) int? used,@JsonKey(name: 'avail', fromJson: proxmoxInt) int? available,@JsonKey(fromJson: storageActiveFromJson) bool active
});




}
/// @nodoc
class _$StorageCopyWithImpl<$Res>
    implements $StorageCopyWith<$Res> {
  _$StorageCopyWithImpl(this._self, this._then);

  final Storage _self;
  final $Res Function(Storage) _then;

/// Create a copy of Storage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? node = null,Object? type = null,Object? content = null,Object? total = freezed,Object? used = freezed,Object? available = freezed,Object? active = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<String>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,used: freezed == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Storage].
extension StoragePatterns on Storage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Storage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Storage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Storage value)  $default,){
final _that = this;
switch (_that) {
case _Storage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Storage value)?  $default,){
final _that = this;
switch (_that) {
case _Storage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'storage')  String id,  String node, @JsonKey(fromJson: proxmoxString)  String type, @JsonKey(name: 'content', fromJson: storageContentKindsFromJson)  List<String> content, @JsonKey(fromJson: proxmoxInt)  int? total, @JsonKey(fromJson: proxmoxInt)  int? used, @JsonKey(name: 'avail', fromJson: proxmoxInt)  int? available, @JsonKey(fromJson: storageActiveFromJson)  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Storage() when $default != null:
return $default(_that.id,_that.node,_that.type,_that.content,_that.total,_that.used,_that.available,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'storage')  String id,  String node, @JsonKey(fromJson: proxmoxString)  String type, @JsonKey(name: 'content', fromJson: storageContentKindsFromJson)  List<String> content, @JsonKey(fromJson: proxmoxInt)  int? total, @JsonKey(fromJson: proxmoxInt)  int? used, @JsonKey(name: 'avail', fromJson: proxmoxInt)  int? available, @JsonKey(fromJson: storageActiveFromJson)  bool active)  $default,) {final _that = this;
switch (_that) {
case _Storage():
return $default(_that.id,_that.node,_that.type,_that.content,_that.total,_that.used,_that.available,_that.active);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'storage')  String id,  String node, @JsonKey(fromJson: proxmoxString)  String type, @JsonKey(name: 'content', fromJson: storageContentKindsFromJson)  List<String> content, @JsonKey(fromJson: proxmoxInt)  int? total, @JsonKey(fromJson: proxmoxInt)  int? used, @JsonKey(name: 'avail', fromJson: proxmoxInt)  int? available, @JsonKey(fromJson: storageActiveFromJson)  bool active)?  $default,) {final _that = this;
switch (_that) {
case _Storage() when $default != null:
return $default(_that.id,_that.node,_that.type,_that.content,_that.total,_that.used,_that.available,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Storage implements Storage {
  const _Storage({@JsonKey(name: 'storage') required this.id, required this.node, @JsonKey(fromJson: proxmoxString) this.type = '', @JsonKey(name: 'content', fromJson: storageContentKindsFromJson) final  List<String> content = const [], @JsonKey(fromJson: proxmoxInt) this.total, @JsonKey(fromJson: proxmoxInt) this.used, @JsonKey(name: 'avail', fromJson: proxmoxInt) this.available, @JsonKey(fromJson: storageActiveFromJson) this.active = false}): _content = content;
  factory _Storage.fromJson(Map<String, dynamic> json) => _$StorageFromJson(json);

/// Pool id (`storage` in PVE JSON).
@override@JsonKey(name: 'storage') final  String id;
@override final  String node;
@override@JsonKey(fromJson: proxmoxString) final  String type;
 final  List<String> _content;
@override@JsonKey(name: 'content', fromJson: storageContentKindsFromJson) List<String> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

@override@JsonKey(fromJson: proxmoxInt) final  int? total;
@override@JsonKey(fromJson: proxmoxInt) final  int? used;
@override@JsonKey(name: 'avail', fromJson: proxmoxInt) final  int? available;
@override@JsonKey(fromJson: storageActiveFromJson) final  bool active;

/// Create a copy of Storage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageCopyWith<_Storage> get copyWith => __$StorageCopyWithImpl<_Storage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Storage&&(identical(other.id, id) || other.id == id)&&(identical(other.node, node) || other.node == node)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._content, _content)&&(identical(other.total, total) || other.total == total)&&(identical(other.used, used) || other.used == used)&&(identical(other.available, available) || other.available == available)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,node,type,const DeepCollectionEquality().hash(_content),total,used,available,active);

@override
String toString() {
  return 'Storage(id: $id, node: $node, type: $type, content: $content, total: $total, used: $used, available: $available, active: $active)';
}


}

/// @nodoc
abstract mixin class _$StorageCopyWith<$Res> implements $StorageCopyWith<$Res> {
  factory _$StorageCopyWith(_Storage value, $Res Function(_Storage) _then) = __$StorageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'storage') String id, String node,@JsonKey(fromJson: proxmoxString) String type,@JsonKey(name: 'content', fromJson: storageContentKindsFromJson) List<String> content,@JsonKey(fromJson: proxmoxInt) int? total,@JsonKey(fromJson: proxmoxInt) int? used,@JsonKey(name: 'avail', fromJson: proxmoxInt) int? available,@JsonKey(fromJson: storageActiveFromJson) bool active
});




}
/// @nodoc
class __$StorageCopyWithImpl<$Res>
    implements _$StorageCopyWith<$Res> {
  __$StorageCopyWithImpl(this._self, this._then);

  final _Storage _self;
  final $Res Function(_Storage) _then;

/// Create a copy of Storage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? node = null,Object? type = null,Object? content = null,Object? total = freezed,Object? used = freezed,Object? available = freezed,Object? active = null,}) {
  return _then(_Storage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<String>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,used: freezed == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
