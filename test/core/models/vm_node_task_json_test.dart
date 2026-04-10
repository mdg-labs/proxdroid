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
      };
      final vm = Vm.fromJson(map);
      final again = Vm.fromJson(vm.toJson());
      expect(again, vm);
      expect(vm.status, VmStatus.stopped);
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
  });
}
