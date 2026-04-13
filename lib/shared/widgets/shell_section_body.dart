import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

/// Reserved vertical space above the bottom shell chrome for FAB positioning.
///
/// Phase 4 ships [NavigationBar] as [Scaffold.bottomNavigationBar], which
/// handles its own layout — the scaffold body is already placed above the bar.
/// This constant is therefore 0; only system view-padding is added to the FAB
/// bottom offset inside [ShellSectionBody].
const double kShellBottomNavReserve = 0;

/// Standard shell layout: [AppBar] + [Expanded] body, optional FAB overlay.
///
/// Use for section screens inside [AppShell]. Pass [title] as [Text] or a custom
/// [Widget]. Body padding is left to the child (e.g. [ListView.padding] or
/// [SliverPadding]) so pull-to-refresh and scroll views stay edge-to-edge.
class ShellSectionBody extends ConsumerWidget {
  const ShellSectionBody({
    super.key,
    required this.title,
    required this.body,
    this.leading,
    this.actions,
    this.floatingActionButton,
  });

  final Widget title;
  final Widget body;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final server = ref.watch(selectedServerProvider);

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: leading ?? shellAppBarLeading(context),
          title: title,
          actions: actions,
          backgroundColor: scaffoldBg.withValues(alpha: 0),
          foregroundColor: scheme.onSurface,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        if (server != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Tooltip(
                message: l10n.shellServerPillTooltip,
                child: Material(
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.go('/servers'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs + 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: scheme.primary),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            l10n.shellConnectedLabel,
                            style: tt.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width * 0.5,
                            ),
                            child: Text(
                              server.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tt.labelMedium?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: scheme.outlineVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        Expanded(child: body),
      ],
    );

    if (floatingActionButton == null) {
      return column;
    }

    final bottomInset =
        MediaQuery.viewPaddingOf(context).bottom + kShellBottomNavReserve + 16;

    return Stack(
      fit: StackFit.expand,
      children: [
        column,
        Positioned(
          right: 16,
          bottom: bottomInset,
          child: floatingActionButton!,
        ),
      ],
    );
  }
}
