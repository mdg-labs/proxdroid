// Curated PVE values for guest create/edit pickers (subset of full PVE docs).

/// QEMU `ostype` — common values for dropdowns.
const List<String> pveQemuOstypeIds = <String>[
  'other',
  'wxp',
  'w2k',
  'w2k3',
  'w2k8',
  'wvista',
  'win7',
  'win8',
  'win10',
  'win11',
  'l24',
  'l26',
  'solaris',
  'wxp64',
  'w2k64',
  'w2k3-64',
  'w2k8-64',
  'wvista-64',
  'win7-64',
  'win8-64',
  'win10-64',
  'win11-64',
  'l24-64',
  'l26-64',
];

/// LXC `ostype` / template OS — common values.
const List<String> pveLxcOstypeIds = <String>[
  'debian',
  'ubuntu',
  'centos',
  'fedora',
  'opensuse',
  'archlinux',
  'alpine',
  'gentoo',
  'nixos',
  'unmanaged',
];

/// QEMU `scsihw` values.
const List<String> pveQemuScsihwIds = <String>[
  'virtio-scsi-single',
  'virtio-scsi-pci',
  'lsi',
  'megasas',
  'pvscsi',
];

/// NIC models for simplified `netN` / `net0` builders (QEMU first token).
const List<String> pveQemuNicModels = <String>[
  'virtio',
  'e1000',
  'e1000e',
  'rtl8139',
  'vmxnet3',
];
