import 'package:flutter/material.dart';
import '../models/alumni.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

// ── Alumni Category Badge ────────────────────────────────────────
class AlumniCategoryBadge extends StatelessWidget {
  final AlumniCategory category;
  const AlumniCategoryBadge({super.key, required this.category});

  Color get _color {
    switch (category) {
      case AlumniCategory.engineering: return AppTheme.accentAlt;
      case AlumniCategory.business: return AppTheme.warning;
      case AlumniCategory.science: return AppTheme.accent;
      case AlumniCategory.education: return AppTheme.accent;
      case AlumniCategory.healthcare: return AppTheme.danger;
      case AlumniCategory.technology: return AppTheme.accentAlt;
    }
  }

  String get _label {
    switch (category) {
      case AlumniCategory.engineering: return 'Engineering';
      case AlumniCategory.business: return 'Business';
      case AlumniCategory.science: return 'Science';
      case AlumniCategory.education: return 'Education';
      case AlumniCategory.healthcare: return 'Healthcare';
      case AlumniCategory.technology: return 'Technology';
    }
  }

  @override
  Widget build(BuildContext context) =>
      AppBadge(label: _label, color: _color);
}

// ── Alumni Photo ─────────────────────────────────────────────────
class AlumniPhoto extends StatelessWidget {
  final String photoUrl;
  final double size;
  const AlumniPhoto({super.key, required this.photoUrl, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        photoUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: AppTheme.surfaceHigh,
          child: const Icon(Icons.person_rounded, color: AppTheme.textSecondary, size: 32),
        ),
      ),
    );
  }
}

// ── Alumni Card ──────────────────────────────────────────────────
class AlumniCard extends StatelessWidget {
  final Alumni alumni;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const AlumniCard({
    super.key,
    required this.alumni,
    required this.onTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AlumniPhoto(photoUrl: alumni.photoUrl),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (alumni.isFeatured)
                                  const AppBadge(label: 'Featured', color: AppTheme.accent),
                                const Spacer(),
                                GestureDetector(
                                  onTap: onSave,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      alumni.isSaved
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      key: ValueKey(alumni.isSaved),
                                      color: alumni.isSaved ? AppTheme.accent : AppTheme.textSecondary,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(alumni.name, style: AppTheme.heading(16)),
                            const SizedBox(height: 3),
                            Text('${alumni.currentRole} at ${alumni.company}', style: AppTheme.label(13, color: AppTheme.accent, weight: FontWeight.w600)),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 12, color: AppTheme.textSecondary),
                                const SizedBox(width: 4),
                                Text(alumni.location, style: AppTheme.label(12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      AlumniCategoryBadge(category: alumni.category),
                      ...alumni.skills.take(3).map((s) => TagChip(label: s)),
                      if (alumni.skills.length > 3)
                        TagChip(label: '+${alumni.skills.length - 3}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    alumni.bio,
                    style: AppTheme.body(13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: AppTheme.surfaceHigh,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.school_outlined, size: 15, color: AppTheme.accentAlt),
                  const SizedBox(width: 3),
                  Text('Class of ${alumni.graduationYear}', style: AppTheme.label(12, color: AppTheme.accentAlt, weight: FontWeight.w600)),
                  const Spacer(),
                  const Icon(Icons.school_rounded, size: 13, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(alumni.program, style: AppTheme.label(12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
