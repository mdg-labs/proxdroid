// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupJob {

 String get id;@JsonKey(name: 'vmid', fromJson: backupVmidsFromJson) List<int> get vmids;@JsonKey(fromJson: proxmoxString) String get storage;@JsonKey(fromJson: proxmoxString) String get schedule;@JsonKey(name: 'last-run', fromJson: proxmoxInt) int? get lastRun;@JsonKey(name: 'next-run', fromJson: proxmoxInt) int? get nextRun;
/// Create a copy of BackupJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupJobCopyWith<BackupJob> get copyWith => _$BackupJobCopyWithImpl<BackupJob>(this as BackupJob, _$identity);

  /// Serializes this BackupJob to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupJob&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.vmids, vmids)&&(identical(other.storage, storage) || other.storage == storage)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.lastRun, lastRun) || other.lastRun == lastRun)&&(identical(other.nextRun, nextRun) || other.nextRun == nextRun));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(vmids),storage,schedule,lastRun,nextRun);

@override
String toString() {
  return 'BackupJob(id: $id, vmids: $vmids, storage: $storage, schedule: $schedule, lastRun: $lastRun, nextRun: $nextRun)';
}


}

/// @nodoc
abstract mixin class $BackupJobCopyWith<$Res>  {
  factory $BackupJobCopyWith(BackupJob value, $Res Function(BackupJob) _then) = _$BackupJobCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'vmid', fromJson: backupVmidsFromJson) List<int> vmids,@JsonKey(fromJson: proxmoxString) String storage,@JsonKey(fromJson: proxmoxString) String schedule,@JsonKey(name: 'last-run', fromJson: proxmoxInt) int? lastRun,@JsonKey(name: 'next-run', fromJson: proxmoxInt) int? nextRun
});




}
/// @nodoc
class _$BackupJobCopyWithImpl<$Res>
    implements $BackupJobCopyWith<$Res> {
  _$BackupJobCopyWithImpl(this._self, this._then);

  final BackupJob _self;
  final $Res Function(BackupJob) _then;

/// Create a copy of BackupJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vmids = null,Object? storage = null,Object? schedule = null,Object? lastRun = freezed,Object? nextRun = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vmids: null == vmids ? _self.vmids : vmids // ignore: cast_nullable_to_non_nullable
as List<int>,storage: null == storage ? _self.storage : storage // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,lastRun: freezed == lastRun ? _self.lastRun : lastRun // ignore: cast_nullable_to_non_nullable
as int?,nextRun: freezed == nextRun ? _self.nextRun : nextRun // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupJob].
extension BackupJobPatterns on BackupJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupJob value)  $default,){
final _that = this;
switch (_that) {
case _BackupJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupJob value)?  $default,){
final _that = this;
switch (_that) {
case _BackupJob() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'vmid', fromJson: backupVmidsFromJson)  List<int> vmids, @JsonKey(fromJson: proxmoxString)  String storage, @JsonKey(fromJson: proxmoxString)  String schedule, @JsonKey(name: 'last-run', fromJson: proxmoxInt)  int? lastRun, @JsonKey(name: 'next-run', fromJson: proxmoxInt)  int? nextRun)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupJob() when $default != null:
return $default(_that.id,_that.vmids,_that.storage,_that.schedule,_that.lastRun,_that.nextRun);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'vmid', fromJson: backupVmidsFromJson)  List<int> vmids, @JsonKey(fromJson: proxmoxString)  String storage, @JsonKey(fromJson: proxmoxString)  String schedule, @JsonKey(name: 'last-run', fromJson: proxmoxInt)  int? lastRun, @JsonKey(name: 'next-run', fromJson: proxmoxInt)  int? nextRun)  $default,) {final _that = this;
switch (_that) {
case _BackupJob():
return $default(_that.id,_that.vmids,_that.storage,_that.schedule,_that.lastRun,_that.nextRun);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'vmid', fromJson: backupVmidsFromJson)  List<int> vmids, @JsonKey(fromJson: proxmoxString)  String storage, @JsonKey(fromJson: proxmoxString)  String schedule, @JsonKey(name: 'last-run', fromJson: proxmoxInt)  int? lastRun, @JsonKey(name: 'next-run', fromJson: proxmoxInt)  int? nextRun)?  $default,) {final _that = this;
switch (_that) {
case _BackupJob() when $default != null:
return $default(_that.id,_that.vmids,_that.storage,_that.schedule,_that.lastRun,_that.nextRun);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupJob implements BackupJob {
  const _BackupJob({required this.id, @JsonKey(name: 'vmid', fromJson: backupVmidsFromJson) final  List<int> vmids = const [], @JsonKey(fromJson: proxmoxString) this.storage = '', @JsonKey(fromJson: proxmoxString) this.schedule = '', @JsonKey(name: 'last-run', fromJson: proxmoxInt) this.lastRun, @JsonKey(name: 'next-run', fromJson: proxmoxInt) this.nextRun}): _vmids = vmids;
  factory _BackupJob.fromJson(Map<String, dynamic> json) => _$BackupJobFromJson(json);

@override final  String id;
 final  List<int> _vmids;
@override@JsonKey(name: 'vmid', fromJson: backupVmidsFromJson) List<int> get vmids {
  if (_vmids is EqualUnmodifiableListView) return _vmids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vmids);
}

@override@JsonKey(fromJson: proxmoxString) final  String storage;
@override@JsonKey(fromJson: proxmoxString) final  String schedule;
@override@JsonKey(name: 'last-run', fromJson: proxmoxInt) final  int? lastRun;
@override@JsonKey(name: 'next-run', fromJson: proxmoxInt) final  int? nextRun;

/// Create a copy of BackupJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupJobCopyWith<_BackupJob> get copyWith => __$BackupJobCopyWithImpl<_BackupJob>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupJobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupJob&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._vmids, _vmids)&&(identical(other.storage, storage) || other.storage == storage)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.lastRun, lastRun) || other.lastRun == lastRun)&&(identical(other.nextRun, nextRun) || other.nextRun == nextRun));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_vmids),storage,schedule,lastRun,nextRun);

@override
String toString() {
  return 'BackupJob(id: $id, vmids: $vmids, storage: $storage, schedule: $schedule, lastRun: $lastRun, nextRun: $nextRun)';
}


}

/// @nodoc
abstract mixin class _$BackupJobCopyWith<$Res> implements $BackupJobCopyWith<$Res> {
  factory _$BackupJobCopyWith(_BackupJob value, $Res Function(_BackupJob) _then) = __$BackupJobCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'vmid', fromJson: backupVmidsFromJson) List<int> vmids,@JsonKey(fromJson: proxmoxString) String storage,@JsonKey(fromJson: proxmoxString) String schedule,@JsonKey(name: 'last-run', fromJson: proxmoxInt) int? lastRun,@JsonKey(name: 'next-run', fromJson: proxmoxInt) int? nextRun
});




}
/// @nodoc
class __$BackupJobCopyWithImpl<$Res>
    implements _$BackupJobCopyWith<$Res> {
  __$BackupJobCopyWithImpl(this._self, this._then);

  final _BackupJob _self;
  final $Res Function(_BackupJob) _then;

/// Create a copy of BackupJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vmids = null,Object? storage = null,Object? schedule = null,Object? lastRun = freezed,Object? nextRun = freezed,}) {
  return _then(_BackupJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vmids: null == vmids ? _self._vmids : vmids // ignore: cast_nullable_to_non_nullable
as List<int>,storage: null == storage ? _self.storage : storage // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,lastRun: freezed == lastRun ? _self.lastRun : lastRun // ignore: cast_nullable_to_non_nullable
as int?,nextRun: freezed == nextRun ? _self.nextRun : nextRun // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$BackupContent {

@JsonKey(fromJson: proxmoxString) String get volid;@JsonKey(fromJson: backupContentVmidFromJson) int? get vmid;@JsonKey(fromJson: proxmoxString) String get format;@JsonKey(fromJson: proxmoxInt) int? get size;@JsonKey(fromJson: proxmoxInt) int? get ctime;/// PVE content kind (e.g. `backup`, `iso`).
@JsonKey(fromJson: proxmoxString) String get content;
/// Create a copy of BackupContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupContentCopyWith<BackupContent> get copyWith => _$BackupContentCopyWithImpl<BackupContent>(this as BackupContent, _$identity);

  /// Serializes this BackupContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupContent&&(identical(other.volid, volid) || other.volid == volid)&&(identical(other.vmid, vmid) || other.vmid == vmid)&&(identical(other.format, format) || other.format == format)&&(identical(other.size, size) || other.size == size)&&(identical(other.ctime, ctime) || other.ctime == ctime)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,volid,vmid,format,size,ctime,content);

@override
String toString() {
  return 'BackupContent(volid: $volid, vmid: $vmid, format: $format, size: $size, ctime: $ctime, content: $content)';
}


}

/// @nodoc
abstract mixin class $BackupContentCopyWith<$Res>  {
  factory $BackupContentCopyWith(BackupContent value, $Res Function(BackupContent) _then) = _$BackupContentCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: proxmoxString) String volid,@JsonKey(fromJson: backupContentVmidFromJson) int? vmid,@JsonKey(fromJson: proxmoxString) String format,@JsonKey(fromJson: proxmoxInt) int? size,@JsonKey(fromJson: proxmoxInt) int? ctime,@JsonKey(fromJson: proxmoxString) String content
});




}
/// @nodoc
class _$BackupContentCopyWithImpl<$Res>
    implements $BackupContentCopyWith<$Res> {
  _$BackupContentCopyWithImpl(this._self, this._then);

  final BackupContent _self;
  final $Res Function(BackupContent) _then;

/// Create a copy of BackupContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? volid = null,Object? vmid = freezed,Object? format = null,Object? size = freezed,Object? ctime = freezed,Object? content = null,}) {
  return _then(_self.copyWith(
volid: null == volid ? _self.volid : volid // ignore: cast_nullable_to_non_nullable
as String,vmid: freezed == vmid ? _self.vmid : vmid // ignore: cast_nullable_to_non_nullable
as int?,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,ctime: freezed == ctime ? _self.ctime : ctime // ignore: cast_nullable_to_non_nullable
as int?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupContent].
extension BackupContentPatterns on BackupContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupContent value)  $default,){
final _that = this;
switch (_that) {
case _BackupContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupContent value)?  $default,){
final _that = this;
switch (_that) {
case _BackupContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: proxmoxString)  String volid, @JsonKey(fromJson: backupContentVmidFromJson)  int? vmid, @JsonKey(fromJson: proxmoxString)  String format, @JsonKey(fromJson: proxmoxInt)  int? size, @JsonKey(fromJson: proxmoxInt)  int? ctime, @JsonKey(fromJson: proxmoxString)  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupContent() when $default != null:
return $default(_that.volid,_that.vmid,_that.format,_that.size,_that.ctime,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: proxmoxString)  String volid, @JsonKey(fromJson: backupContentVmidFromJson)  int? vmid, @JsonKey(fromJson: proxmoxString)  String format, @JsonKey(fromJson: proxmoxInt)  int? size, @JsonKey(fromJson: proxmoxInt)  int? ctime, @JsonKey(fromJson: proxmoxString)  String content)  $default,) {final _that = this;
switch (_that) {
case _BackupContent():
return $default(_that.volid,_that.vmid,_that.format,_that.size,_that.ctime,_that.content);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: proxmoxString)  String volid, @JsonKey(fromJson: backupContentVmidFromJson)  int? vmid, @JsonKey(fromJson: proxmoxString)  String format, @JsonKey(fromJson: proxmoxInt)  int? size, @JsonKey(fromJson: proxmoxInt)  int? ctime, @JsonKey(fromJson: proxmoxString)  String content)?  $default,) {final _that = this;
switch (_that) {
case _BackupContent() when $default != null:
return $default(_that.volid,_that.vmid,_that.format,_that.size,_that.ctime,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupContent implements BackupContent {
  const _BackupContent({@JsonKey(fromJson: proxmoxString) required this.volid, @JsonKey(fromJson: backupContentVmidFromJson) this.vmid, @JsonKey(fromJson: proxmoxString) this.format = '', @JsonKey(fromJson: proxmoxInt) this.size, @JsonKey(fromJson: proxmoxInt) this.ctime, @JsonKey(fromJson: proxmoxString) this.content = ''});
  factory _BackupContent.fromJson(Map<String, dynamic> json) => _$BackupContentFromJson(json);

@override@JsonKey(fromJson: proxmoxString) final  String volid;
@override@JsonKey(fromJson: backupContentVmidFromJson) final  int? vmid;
@override@JsonKey(fromJson: proxmoxString) final  String format;
@override@JsonKey(fromJson: proxmoxInt) final  int? size;
@override@JsonKey(fromJson: proxmoxInt) final  int? ctime;
/// PVE content kind (e.g. `backup`, `iso`).
@override@JsonKey(fromJson: proxmoxString) final  String content;

/// Create a copy of BackupContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupContentCopyWith<_BackupContent> get copyWith => __$BackupContentCopyWithImpl<_BackupContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupContent&&(identical(other.volid, volid) || other.volid == volid)&&(identical(other.vmid, vmid) || other.vmid == vmid)&&(identical(other.format, format) || other.format == format)&&(identical(other.size, size) || other.size == size)&&(identical(other.ctime, ctime) || other.ctime == ctime)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,volid,vmid,format,size,ctime,content);

@override
String toString() {
  return 'BackupContent(volid: $volid, vmid: $vmid, format: $format, size: $size, ctime: $ctime, content: $content)';
}


}

/// @nodoc
abstract mixin class _$BackupContentCopyWith<$Res> implements $BackupContentCopyWith<$Res> {
  factory _$BackupContentCopyWith(_BackupContent value, $Res Function(_BackupContent) _then) = __$BackupContentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: proxmoxString) String volid,@JsonKey(fromJson: backupContentVmidFromJson) int? vmid,@JsonKey(fromJson: proxmoxString) String format,@JsonKey(fromJson: proxmoxInt) int? size,@JsonKey(fromJson: proxmoxInt) int? ctime,@JsonKey(fromJson: proxmoxString) String content
});




}
/// @nodoc
class __$BackupContentCopyWithImpl<$Res>
    implements _$BackupContentCopyWith<$Res> {
  __$BackupContentCopyWithImpl(this._self, this._then);

  final _BackupContent _self;
  final $Res Function(_BackupContent) _then;

/// Create a copy of BackupContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? volid = null,Object? vmid = freezed,Object? format = null,Object? size = freezed,Object? ctime = freezed,Object? content = null,}) {
  return _then(_BackupContent(
volid: null == volid ? _self.volid : volid // ignore: cast_nullable_to_non_nullable
as String,vmid: freezed == vmid ? _self.vmid : vmid // ignore: cast_nullable_to_non_nullable
as int?,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,ctime: freezed == ctime ? _self.ctime : ctime // ignore: cast_nullable_to_non_nullable
as int?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
