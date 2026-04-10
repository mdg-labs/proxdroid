/// Top-level shell locations where the app bar shows the drawer (hamburger),
/// not the back button. Must match [AppShell] primary sections.
const Set<String> kShellDrawerRootPaths = {
  '/servers',
  '/dashboard',
  '/vms',
  '/containers',
  '/storage',
  '/backups',
  '/tasks',
  '/settings',
};

/// Normalizes [rawPath] (trailing slash) and returns whether it is a drawer root.
bool isShellDrawerRootPath(String rawPath) {
  if (rawPath.isEmpty || rawPath == '/') {
    return false;
  }
  var path = rawPath;
  if (path.length > 1 && path.endsWith('/')) {
    path = path.substring(0, path.length - 1);
  }
  return kShellDrawerRootPaths.contains(path);
}
