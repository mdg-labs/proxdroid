import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/shared/routing/shell_drawer_root_paths.dart';

void main() {
  test('isShellDrawerRootPath is true for section roots', () {
    expect(isShellDrawerRootPath('/vms'), isTrue);
    expect(isShellDrawerRootPath('/servers'), isTrue);
    expect(isShellDrawerRootPath('/dashboard'), isTrue);
    expect(isShellDrawerRootPath('/settings'), isTrue);
  });

  test('isShellDrawerRootPath normalizes trailing slash', () {
    expect(isShellDrawerRootPath('/vms/'), isTrue);
  });

  test('isShellDrawerRootPath is false for nested routes', () {
    expect(isShellDrawerRootPath('/vms/n1/100'), isFalse);
    expect(isShellDrawerRootPath('/dashboard/pve1'), isFalse);
    expect(isShellDrawerRootPath('/servers/add'), isFalse);
    expect(isShellDrawerRootPath('/servers/edit/x'), isFalse);
    expect(isShellDrawerRootPath('/storage/n1/local'), isFalse);
  });

  test('isShellDrawerRootPath is false for empty or root only', () {
    expect(isShellDrawerRootPath(''), isFalse);
    expect(isShellDrawerRootPath('/'), isFalse);
  });
}
