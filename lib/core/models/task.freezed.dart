// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Task {

@JsonKey(fromJson: _taskUpidFromJson) String get upid;@JsonKey(fromJson: _taskNodeFromJson) String get node;@JsonKey(fromJson: _taskTypeFromJson) String get type;@JsonKey(fromJson: _taskStatusFromJson, toJson: _taskStatusToJson) TaskStatus get status;@JsonKey(name: 'starttime', fromJson: proxmoxInt) int? get startTime;@JsonKey(name: 'endtime', fromJson: proxmoxInt) int? get endTime;@JsonKey(fromJson: proxmoxString) String get user;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.upid, upid) || other.upid == upid)&&(identical(other.node, node) || other.node == node)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,upid,node,type,status,startTime,endTime,user);

@override
String toString() {
  return 'Task(upid: $upid, node: $node, type: $type, status: $status, startTime: $startTime, endTime: $endTime, user: $user)';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _taskUpidFromJson) String upid,@JsonKey(fromJson: _taskNodeFromJson) String node,@JsonKey(fromJson: _taskTypeFromJson) String type,@JsonKey(fromJson: _taskStatusFromJson, toJson: _taskStatusToJson) TaskStatus status,@JsonKey(name: 'starttime', fromJson: proxmoxInt) int? startTime,@JsonKey(name: 'endtime', fromJson: proxmoxInt) int? endTime,@JsonKey(fromJson: proxmoxString) String user
});




}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? upid = null,Object? node = null,Object? type = null,Object? status = null,Object? startTime = freezed,Object? endTime = freezed,Object? user = null,}) {
  return _then(_self.copyWith(
upid: null == upid ? _self.upid : upid // ignore: cast_nullable_to_non_nullable
as String,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as int?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as int?,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _taskUpidFromJson)  String upid, @JsonKey(fromJson: _taskNodeFromJson)  String node, @JsonKey(fromJson: _taskTypeFromJson)  String type, @JsonKey(fromJson: _taskStatusFromJson, toJson: _taskStatusToJson)  TaskStatus status, @JsonKey(name: 'starttime', fromJson: proxmoxInt)  int? startTime, @JsonKey(name: 'endtime', fromJson: proxmoxInt)  int? endTime, @JsonKey(fromJson: proxmoxString)  String user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.upid,_that.node,_that.type,_that.status,_that.startTime,_that.endTime,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _taskUpidFromJson)  String upid, @JsonKey(fromJson: _taskNodeFromJson)  String node, @JsonKey(fromJson: _taskTypeFromJson)  String type, @JsonKey(fromJson: _taskStatusFromJson, toJson: _taskStatusToJson)  TaskStatus status, @JsonKey(name: 'starttime', fromJson: proxmoxInt)  int? startTime, @JsonKey(name: 'endtime', fromJson: proxmoxInt)  int? endTime, @JsonKey(fromJson: proxmoxString)  String user)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.upid,_that.node,_that.type,_that.status,_that.startTime,_that.endTime,_that.user);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _taskUpidFromJson)  String upid, @JsonKey(fromJson: _taskNodeFromJson)  String node, @JsonKey(fromJson: _taskTypeFromJson)  String type, @JsonKey(fromJson: _taskStatusFromJson, toJson: _taskStatusToJson)  TaskStatus status, @JsonKey(name: 'starttime', fromJson: proxmoxInt)  int? startTime, @JsonKey(name: 'endtime', fromJson: proxmoxInt)  int? endTime, @JsonKey(fromJson: proxmoxString)  String user)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.upid,_that.node,_that.type,_that.status,_that.startTime,_that.endTime,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Task implements Task {
  const _Task({@JsonKey(fromJson: _taskUpidFromJson) required this.upid, @JsonKey(fromJson: _taskNodeFromJson) required this.node, @JsonKey(fromJson: _taskTypeFromJson) required this.type, @JsonKey(fromJson: _taskStatusFromJson, toJson: _taskStatusToJson) required this.status, @JsonKey(name: 'starttime', fromJson: proxmoxInt) this.startTime, @JsonKey(name: 'endtime', fromJson: proxmoxInt) this.endTime, @JsonKey(fromJson: proxmoxString) this.user = ''});
  factory _Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

@override@JsonKey(fromJson: _taskUpidFromJson) final  String upid;
@override@JsonKey(fromJson: _taskNodeFromJson) final  String node;
@override@JsonKey(fromJson: _taskTypeFromJson) final  String type;
@override@JsonKey(fromJson: _taskStatusFromJson, toJson: _taskStatusToJson) final  TaskStatus status;
@override@JsonKey(name: 'starttime', fromJson: proxmoxInt) final  int? startTime;
@override@JsonKey(name: 'endtime', fromJson: proxmoxInt) final  int? endTime;
@override@JsonKey(fromJson: proxmoxString) final  String user;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.upid, upid) || other.upid == upid)&&(identical(other.node, node) || other.node == node)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,upid,node,type,status,startTime,endTime,user);

@override
String toString() {
  return 'Task(upid: $upid, node: $node, type: $type, status: $status, startTime: $startTime, endTime: $endTime, user: $user)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _taskUpidFromJson) String upid,@JsonKey(fromJson: _taskNodeFromJson) String node,@JsonKey(fromJson: _taskTypeFromJson) String type,@JsonKey(fromJson: _taskStatusFromJson, toJson: _taskStatusToJson) TaskStatus status,@JsonKey(name: 'starttime', fromJson: proxmoxInt) int? startTime,@JsonKey(name: 'endtime', fromJson: proxmoxInt) int? endTime,@JsonKey(fromJson: proxmoxString) String user
});




}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? upid = null,Object? node = null,Object? type = null,Object? status = null,Object? startTime = freezed,Object? endTime = freezed,Object? user = null,}) {
  return _then(_Task(
upid: null == upid ? _self.upid : upid // ignore: cast_nullable_to_non_nullable
as String,node: null == node ? _self.node : node // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as int?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as int?,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
