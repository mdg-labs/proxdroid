/// Proxmox UPID parsing helpers.
///
/// Typical UPID shape (colon-separated):
/// `UPID:<node>:<pid_hex>:<pstart>:<starttime_hex>:<type>:<id>:<user@realm>:`
///
/// For many guest-related tasks (`qmstart`, `qmstop`, `lxc_start`, `vzdump`,
/// etc.) the field immediately before `<user@realm>` is a numeric VM/CT ID.
/// Some task types use a non-numeric or empty [id] field, or omit a guest ID
/// entirely — this helper returns [null] in those cases.
///
/// **Limitations:** Does not handle non-standard UPID variants; may return
/// [null] for cluster-wide or storage tasks; if [id] is numeric but not a
/// guest ID (rare), parsing could theoretically mislabel it as a vmid.
int? vmidFromProxmoxUpid(String upid) {
  final parts = upid.split(':');
  if (parts.length < 8) {
    return null;
  }
  if (parts.first != 'UPID') {
    return null;
  }
  final idField = parts[6];
  final vmid = int.tryParse(idField);
  if (vmid == null || vmid <= 0) {
    return null;
  }
  return vmid;
}
