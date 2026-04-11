import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/models/guest_config_indexed_line.dart';
import 'package:proxdroid/core/models/lxc_container_config.dart';
import 'package:proxdroid/core/models/qemu_vm_config.dart';
import 'package:proxdroid/core/models/vm_lxc_config_delta.dart';

void main() {
  group('qemuVmConfigDeltaResult', () {
    test(
      'removing net1 emits delete=net1 and unchanged net0 omitted from body',
      () {
        final original = QemuVmConfig.fromProxmoxConfigData(<String, dynamic>{
          'vmid': 100,
          'name': 't',
          'net0': 'virtio=AA:BB,bridge=vmbr0',
          'net1': 'virtio=CC:DD,bridge=vmbr1',
        });
        final edited = original.copyWith(
          netLines: <GuestConfigIndexedLine>[
            const GuestConfigIndexedLine(
              apiKey: 'net0',
              value: 'virtio=AA:BB,bridge=vmbr0',
            ),
          ],
        );
        final r = qemuVmConfigDeltaResult(original, edited);
        expect(r.body, isEmpty);
        expect(r.deleteKeys, unorderedEquals(<String>['net1']));
      },
    );

    test('nvme0 is modeled as a disk line and can delta', () {
      final original = QemuVmConfig.fromProxmoxConfigData(<String, dynamic>{
        'vmid': 1,
        'name': 'nv',
        'nvme0': 'local-lvm:vm-1-disk-0,size=32G',
      });
      expect(original.diskLines.single.apiKey, 'nvme0');
      final edited = original.copyWith(
        diskLines: <GuestConfigIndexedLine>[
          const GuestConfigIndexedLine(
            apiKey: 'nvme0',
            value: 'local-lvm:vm-1-disk-0,size=64G',
          ),
        ],
      );
      final r = qemuVmConfigDeltaResult(original, edited);
      expect(r.deleteKeys, isEmpty);
      expect(r.body.keys, unorderedEquals(<String>['nvme0']));
    });

    test('changing scsi0 value emits only scsi0 in body', () {
      final original = QemuVmConfig.fromProxmoxConfigData(<String, dynamic>{
        'vmid': 1,
        'name': 'x',
        'scsi0': 'local-lvm:vm-1-disk-0,size=8G',
      });
      final edited = original.copyWith(
        diskLines: <GuestConfigIndexedLine>[
          const GuestConfigIndexedLine(
            apiKey: 'scsi0',
            value: 'local-lvm:vm-1-disk-0,size=16G',
          ),
        ],
      );
      final r = qemuVmConfigDeltaResult(original, edited);
      expect(r.deleteKeys, isEmpty);
      expect(r.body.keys, unorderedEquals(<String>['scsi0']));
      expect(r.body['scsi0'], contains('16G'));
    });
  });

  group('lxcContainerConfigDeltaResult', () {
    test('removing mp1 emits delete=mp1', () {
      final original =
          LxcContainerConfig.fromProxmoxConfigData(<String, dynamic>{
            'vmid': 200,
            'hostname': 'c',
            'mp0': 'local-lvm:1,mp=/srv',
            'mp1': 'local-lvm:2,mp=/data',
          });
      final edited = original.copyWith(
        mpLines: <GuestConfigIndexedLine>[
          const GuestConfigIndexedLine(
            apiKey: 'mp0',
            value: 'local-lvm:1,mp=/srv',
          ),
        ],
      );
      final r = lxcContainerConfigDeltaResult(original, edited);
      expect(r.body, isEmpty);
      expect(r.deleteKeys, unorderedEquals(<String>['mp1']));
    });

    test('rootfs change is flagged as high-risk', () {
      final original = LxcContainerConfig.fromProxmoxConfigData(
        <String, dynamic>{
          'vmid': 200,
          'hostname': 'c',
          'rootfs': 'a:1,size=1G',
        },
      );
      final edited = original.copyWith(rootfs: 'a:1,size=2G');
      final r = lxcContainerConfigDeltaResult(original, edited);
      expect(r.needsRiskConfirmation, isTrue);
      expect(r.body['rootfs'], 'a:1,size=2G');
    });
  });
}
