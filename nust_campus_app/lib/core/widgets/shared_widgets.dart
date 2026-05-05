// ============================================================
//  core/widgets/shared_widgets.dart
//  SHARED WIDGETS — any module can import and use these.
//  Add common components here; keep module-specific widgets
//  inside lib/features/<module>/widgets/.
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ── Pill / Badge ─────────────────────────────────────────────
class AppBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const AppBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: AppTheme.label(11, color: textColor ?? color, weight: FontWeight.w700),
      ),
    );
  }
}

// ── Filter Pill ───────────────────────────────────────────────
class FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent : AppTheme.surfaceHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.accent : AppTheme.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.label(
            13,
            color: selected ? Colors.white : AppTheme.textSecondary,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Tag Chip ──────────────────────────────────────────────────
class TagChip extends StatelessWidget {
  final String label;
  final bool highlighted;

  const TagChip({super.key, required this.label, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: highlighted ? AppTheme.accentGlow : AppTheme.tagBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: highlighted
              ? AppTheme.accent.withOpacity(0.6)
              : AppTheme.cardBorder,
        ),
      ),
      child: Text(
        label,
        style: AppTheme.label(
          12,
          color: highlighted ? AppTheme.accent : AppTheme.textSecondary,
          weight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── App Card Container ────────────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

// ── Stats Card ────────────────────────────────────────────────
class StatsCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const StatsCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 6),
            Text(value, style: AppTheme.heading(18).copyWith(color: color)),
            Text(label, style: AppTheme.label(10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTheme.heading(18)),
        const Spacer(),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: AppTheme.label(13, color: AppTheme.accent, weight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}

// ── Empty State ───────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(title, style: AppTheme.heading(20)),
          const SizedBox(height: 8),
          Text(subtitle, style: AppTheme.label(14), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ── Primary Button ────────────────────────────────────────────
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? icon;
  final bool outline;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.icon,
    this.outline = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppTheme.accent;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: outline ? Colors.transparent : bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: bg, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: outline ? bg : Colors.white, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTheme.label(
                15,
                color: outline ? bg : Colors.white,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
