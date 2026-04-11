/// Result of `POST /nodes/{node}/qemu` or `POST /nodes/{node}/lxc` (create guest).
///
/// [vmid] is the id sent in the create request. [upid] is set when Proxmox
/// returns an async task UPID in the response `data` field — callers should
/// poll task status until terminal.
class GuestCreateResult {
  const GuestCreateResult({required this.vmid, this.upid});

  final int vmid;

  /// Task UPID when create is asynchronous; null when no follow-up poll is needed.
  final String? upid;
}
