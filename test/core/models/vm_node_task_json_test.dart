import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/core/models/task.dart';
import 'package:proxdroid/core/models/vm.dart';

void main() {
  group('Vm', () {
    test('fromJson / toJson roundtrip', () {
      final map = <String, dynamic>{
        'vmid': 101,
        'name': 'db',
        'status': 'stopped',
        'node': 'n2',
        'cpu': 0.0,
        'maxmem': 2147483648,
        'mem': 0,
        'maxdisk': 10737418240,
        'disk': 1024,
        'uptime': 0,
        'tags': 'prod;web',
      };
      final vm = Vm.fromJson(map);
      final again = Vm.fromJson(vm.toJson());
      expect(again, vm);
      expect(vm.status, VmStatus.stopped);
      expect(vm.tags, hasLength(2));
      expect(vm.tags.map((t) => t.label), ['prod', 'web']);
    });
  });

  group('Node', () {
    test('fromJson / toJson roundtrip', () {
      final map = <String, dynamic>{
        'node': 'pve1',
        'status': 'online',
        'maxcpu': 4,
        'cpu': 0.25,
        'mem': 8000000000,
        'maxmem': 16000000000,
      };
      final node = Node.fromJson(map);
      final again = Node.fromJson(node.toJson());
      expect(again, node);
    });
  });

  group('Task', () {
    test('fromJson / toJson roundtrip', () {
      final map = <String, dynamic>{
        'upid': 'UPID:x:1:2',
        'node': 'pve',
        'type': 'qmstart',
        'status': 'running',
        'starttime': 1700000000,
        'endtime': 0,
        'user': 'root@pam',
      };
      final task = Task.fromJson(map);
      final again = Task.fromJson(task.toJson());
      expect(again, task);
      expect(task.status, TaskStatus.running);
    });

    test('fromJson maps TASK ERROR in type to Failed when status missing', () {
      final map = <String, dynamic>{
        'upid': 'UPID:x:1:2',
        'node': 'pve',
        'type': 'TASK ERROR: VM is locked (backup)',
        'starttime': 1700000000,
        'user': 'root@pam',
      };
      final task = Task.fromJson(map);
      expect(task.status, TaskStatus.error);
      expect(task.type, 'TASK ERROR: VM is locked (backup)');
    });

    test('fromJson keeps explicit status when present', () {
      final map = <String, dynamic>{
        'upid': 'UPID:x:1:2',
        'node': 'pve',
        'type': 'TASK ERROR: should not matter',
        'status': 'running',
        'starttime': 1700000000,
        'user': 'root@pam',
      };
      expect(Task.fromJson(map).status, TaskStatus.running);
    });
  });

  group('taskStatusFromApiData', () {
    test('stopped + OK exitstatus → ok', () {
      expect(
        taskStatusFromApiData(<String, dynamic>{
          'status': 'stopped',
          'exitstatus': 'OK',
        }),
        TaskStatus.ok,
      );
    });

    test('stopped + lowercase ok exitstatus → ok', () {
      expect(
        taskStatusFromApiData(<String, dynamic>{
          'status': 'stopped',
          'exitstatus': 'ok',
        }),
        TaskStatus.ok,
      );
    });

    test('stopped + missing exitstatus → ok', () {
      expect(
        taskStatusFromApiData(<String, dynamic>{'status': 'stopped'}),
        TaskStatus.ok,
      );
    });

    test('stopped + TASK ERROR exitstatus → error', () {
      expect(
        taskStatusFromApiData(<String, dynamic>{
          'status': 'stopped',
          'exitstatus': 'TASK ERROR: VM is locked (backup)',
        }),
        TaskStatus.error,
      );
    });

    test('running → running', () {
      expect(
        taskStatusFromApiData(<String, dynamic>{'status': 'running'}),
        TaskStatus.running,
      );
    });
  });
}
