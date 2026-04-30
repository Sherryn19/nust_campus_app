// features/jobs/widgets/job_widgets.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/job.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

// ── Job Type Badge ────────────────────────────────────────────
class JobTypeBadge extends StatelessWidget {
  final JobType type;
  const JobTypeBadge({super.key, required this.type});

  Color get _color {
    switch (type) {
      case JobType.internship: return AppTheme.danger;
      case JobType.fullTime:   return AppTheme.accentAlt;
      case JobType.partTime:   return AppTheme.warning;
      case JobType.remote:     return AppTheme.accent;
    }
  }

  String get _label {
    switch (type) {
      case JobType.internship: return 'Internship';
      case JobType.fullTime:   return 'Full-Time';
      case JobType.partTime:   return 'Part-Time';
      case JobType.remote:     return 'Remote';
    }
  }

  @override
  Widget build(BuildContext context) =>
      AppBadge(label: _label, color: _color);
}

// ── Company Logo ──────────────────────────────────────────────
class CompanyLogo extends StatelessWidget {
  final String logoUrl;
  final double size;
  const CompanyLogo({super.key, required this.logoUrl, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        logoUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: AppTheme.surfaceHigh,
          child: const Icon(Icons.business_rounded, color: AppTheme.textSecondary, size: 24),
        ),
      ),
    );
  }
}

// ── Job Card ──────────────────────────────────────────────────
class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;
  final VoidCallback onBookmark;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
    required this.onBookmark,
  });

  String _daysAgo() {
    final diff = DateTime.now().difference(job.postedDate).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return '1d ago';
    return '${diff}d ago';
  }

  String _deadlineLabel() {
    final diff = job.deadline.difference(DateTime.now()).inDays;
    if (diff < 0) return 'Closed';
    if (diff == 0) return 'Closes today!';
    if (diff <= 3) return '$diff days left';
    return 'Due ${DateFormat('d MMM').format(job.deadline)}';
  }

  bool get _isUrgent => job.deadline.difference(DateTime.now()).inDays <= 3;

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
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4)),
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
                      CompanyLogo(logoUrl: job.logoUrl),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                JobTypeBadge(type: job.type),
                                const Spacer(),
                                GestureDetector(
                                  onTap: onBookmark,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      job.isBookmarked
                                          ? Icons.bookmark_rounded
                                          : Icons.bookmark_outline_rounded,
                                      key: ValueKey(job.isBookmarked),
                                      color: job.isBookmarked ? AppTheme.accent : AppTheme.textSecondary,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(job.title, style: AppTheme.heading(15)),
                            const SizedBox(height: 3),
                            Text(job.company, style: AppTheme.label(13, color: AppTheme.accent, weight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(job.location, style: AppTheme.label(12)),
                      const SizedBox(width: 14),
                      const Icon(Icons.people_outline_rounded, size: 13, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text('${job.applicants} applicants', style: AppTheme.label(12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...job.skills.take(3).map((s) => TagChip(label: s)),
                      if (job.skills.length > 3)
                        TagChip(label: '+${job.skills.length - 3}'),
                    ],
                  ),
                ],
              ),
            ),
            // Bottom bar
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
                  const Icon(Icons.attach_money_rounded, size: 15, color: AppTheme.accentAlt),
                  const SizedBox(width: 3),
                  Text(job.salary, style: AppTheme.label(12, color: AppTheme.accentAlt, weight: FontWeight.w600)),
                  const Spacer(),
                  Icon(
                    _isUrgent ? Icons.timer_outlined : Icons.calendar_today_outlined,
                    size: 13,
                    color: _isUrgent ? AppTheme.danger : AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _deadlineLabel(),
                    style: AppTheme.label(12,
                      color: _isUrgent ? AppTheme.danger : AppTheme.textSecondary,
                      weight: _isUrgent ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(_daysAgo(), style: AppTheme.label(12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
