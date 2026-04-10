// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Server {

 String get id; String get name; String get host; int get port; ServerAuthType get authType; bool get allowSelfSigned;
/// Create a copy of Server
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerCopyWith<Server> get copyWith => _$ServerCopyWithImpl<Server>(this as Server, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Server&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.authType, authType) || other.authType == authType)&&(identical(other.allowSelfSigned, allowSelfSigned) || other.allowSelfSigned == allowSelfSigned));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,host,port,authType,allowSelfSigned);

@override
String toString() {
  return 'Server(id: $id, name: $name, host: $host, port: $port, authType: $authType, allowSelfSigned: $allowSelfSigned)';
}


}

/// @nodoc
abstract mixin class $ServerCopyWith<$Res>  {
  factory $ServerCopyWith(Server value, $Res Function(Server) _then) = _$ServerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String host, int port, ServerAuthType authType, bool allowSelfSigned
});




}
/// @nodoc
class _$ServerCopyWithImpl<$Res>
    implements $ServerCopyWith<$Res> {
  _$ServerCopyWithImpl(this._self, this._then);

  final Server _self;
  final $Res Function(Server) _then;

/// Create a copy of Server
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? host = null,Object? port = null,Object? authType = null,Object? allowSelfSigned = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,authType: null == authType ? _self.authType : authType // ignore: cast_nullable_to_non_nullable
as ServerAuthType,allowSelfSigned: null == allowSelfSigned ? _self.allowSelfSigned : allowSelfSigned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Server].
extension ServerPatterns on Server {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Server value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Server() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Server value)  $default,){
final _that = this;
switch (_that) {
case _Server():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Server value)?  $default,){
final _that = this;
switch (_that) {
case _Server() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String host,  int port,  ServerAuthType authType,  bool allowSelfSigned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Server() when $default != null:
return $default(_that.id,_that.name,_that.host,_that.port,_that.authType,_that.allowSelfSigned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String host,  int port,  ServerAuthType authType,  bool allowSelfSigned)  $default,) {final _that = this;
switch (_that) {
case _Server():
return $default(_that.id,_that.name,_that.host,_that.port,_that.authType,_that.allowSelfSigned);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String host,  int port,  ServerAuthType authType,  bool allowSelfSigned)?  $default,) {final _that = this;
switch (_that) {
case _Server() when $default != null:
return $default(_that.id,_that.name,_that.host,_that.port,_that.authType,_that.allowSelfSigned);case _:
  return null;

}
}

}

/// @nodoc


class _Server implements Server {
  const _Server({required this.id, required this.name, required this.host, required this.port, required this.authType, required this.allowSelfSigned});
  

@override final  String id;
@override final  String name;
@override final  String host;
@override final  int port;
@override final  ServerAuthType authType;
@override final  bool allowSelfSigned;

/// Create a copy of Server
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerCopyWith<_Server> get copyWith => __$ServerCopyWithImpl<_Server>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Server&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.authType, authType) || other.authType == authType)&&(identical(other.allowSelfSigned, allowSelfSigned) || other.allowSelfSigned == allowSelfSigned));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,host,port,authType,allowSelfSigned);

@override
String toString() {
  return 'Server(id: $id, name: $name, host: $host, port: $port, authType: $authType, allowSelfSigned: $allowSelfSigned)';
}


}

/// @nodoc
abstract mixin class _$ServerCopyWith<$Res> implements $ServerCopyWith<$Res> {
  factory _$ServerCopyWith(_Server value, $Res Function(_Server) _then) = __$ServerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String host, int port, ServerAuthType authType, bool allowSelfSigned
});




}
/// @nodoc
class __$ServerCopyWithImpl<$Res>
    implements _$ServerCopyWith<$Res> {
  __$ServerCopyWithImpl(this._self, this._then);

  final _Server _self;
  final $Res Function(_Server) _then;

/// Create a copy of Server
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? host = null,Object? port = null,Object? authType = null,Object? allowSelfSigned = null,}) {
  return _then(_Server(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,authType: null == authType ? _self.authType : authType // ignore: cast_nullable_to_non_nullable
as ServerAuthType,allowSelfSigned: null == allowSelfSigned ? _self.allowSelfSigned : allowSelfSigned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
