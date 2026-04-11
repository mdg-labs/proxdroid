// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_network_iface.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NodeNetworkIface _$NodeNetworkIfaceFromJson(Map<String, dynamic> json) =>
    _NodeNetworkIface(
      iface: proxmoxString(json['iface']),
      type: json['type'] == null ? '' : proxmoxString(json['type']),
    );

Map<String, dynamic> _$NodeNetworkIfaceToJson(_NodeNetworkIface instance) =>
    <String, dynamic>{'iface': instance.iface, 'type': instance.type};
