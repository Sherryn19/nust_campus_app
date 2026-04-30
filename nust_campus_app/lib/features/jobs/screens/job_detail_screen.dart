// features/jobs/screens/job_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/job.dart';
import '../widgets/job_widgets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;
  final VoidCallback onBookmark;

  const JobDetailScreen({
    super.key,
    required this.job,
    required this.onBookmark,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = job.deadline.difference(DateTime.now()).inDays;
    final isUrgent = daysLeft >= 0 && daysLeft <= 3;
    final isClosed = daysLeft < 0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero AppBar ──────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceHigh,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textPrimary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    job.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                    key: ValueKey(job.isBookmarked),
                    color: job.isBookmarked ? AppTheme.accent : AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
                onPressed: onBookmark,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1A1A2E), AppTheme.background],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CompanyLogo(logoUrl: job.logoUrl, size: 56),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  JobTypeBadge(type: job.type),
                                  const SizedBox(height: 8),
                                  Text(job.title, style: AppTheme.heading(20)),
                                  const SizedBox(height: 4),
                                  Text(
                                    job.company,
                                    style: AppTheme.label(14, color: AppTheme.accent, weight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick info row
                  AppCard(
                    child: Row(
                      children: [
                        _infoItem(Icons.location_on_outlined, job.location),
                        _divider(),
                        _infoItem(Icons.attach_money_rounded, job.salary, color: AppTheme.accentAlt),
                        _divider(),
                        _infoItem(Icons.people_outline_rounded, '${job.applicants} applied'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Deadline banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isClosed
                          ? AppTheme.danger.withOpacity(0.08)
                          : isUrgent
                              ? AppTheme.warning.withOpacity(0.08)
                              : AppTheme.accentGlow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isClosed
                            ? AppTheme.danger.withOpacity(0.3)
                            : isUrgent
                                ? AppTheme.warning.withOpacity(0.3)
                                : AppTheme.accent.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isClosed ? Icons.block_rounded : Icons.calendar_today_rounded,
                          size: 16,
                          color: isClosed ? AppTheme.danger : isUrgent ? AppTheme.warning : AppTheme.accent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isClosed
                              ? 'Applications closed'
                              : daysLeft == 0
                                  ? 'Deadline is TODAY!'
                                  : 'Deadline: ${DateFormat('d MMMM yyyy').format(job.deadline)} ($daysLeft days left)',
                          style: AppTheme.label(
                            13,
                            color: isClosed ? AppTheme.danger : isUrgent ? AppTheme.warning : AppTheme.accent,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text('About the Role', style: AppTheme.heading(18)),
                  const SizedBox(height: 10),
                  Text(job.description, style: AppTheme.body(14, color: AppTheme.textSecondary)),
                  const SizedBox(height: 24),

                  // Skills
                  Text('Required Skills', style: AppTheme.heading(18)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: job.skills.map((s) => TagChip(label: s, highlighted: true)).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Responsibilities
                  Text('Responsibilities', style: AppTheme.heading(18)),
                  const SizedBox(height: 10),
                  ...job.responsibilities.map((r) => _bulletItem(r)),
                  const SizedBox(height: 24),

                  // Requirements
                  Text('Requirements', style: AppTheme.heading(18)),
                  const SizedBox(height: 10),
                  ...job.requirements.map((r) => _bulletItem(r)),
                  const SizedBox(height: 24),

                  // Company links
                  Text('Company', style: AppTheme.heading(18)),
                  const SizedBox(height: 10),
                  AppCard(
                    child: Row(
                      children: [
                        CompanyLogo(logoUrl: job.logoUrl, size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job.company, style: AppTheme.body(15)),
                              const SizedBox(height: 2),
                              Text(job.companyWebsite, style: AppTheme.label(12, color: AppTheme.accent)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.open_in_new_rounded, color: AppTheme.accent, size: 18),
                          onPressed: () => _launchUrl(job.companyWebsite),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // space for FAB
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Apply Button ──────────────────────────────────────
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isClosed
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => _launchUrl(job.applicationLink),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.accent, Color(0xFF8B83FF)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accent.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          'Apply Now',
                          style: AppTheme.label(16, color: Colors.white, weight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _infoItem(IconData icon, String text, {Color? color}) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: color ?? AppTheme.textSecondary),
          const SizedBox(height: 4),
          Text(
            text,
            style: AppTheme.label(11, color: color ?? AppTheme.textSecondary),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        height: 36,
        width: 1,
        color: AppTheme.cardBorder,
        margin: const EdgeInsets.symmetric(horizontal: 8),
      );

  Widget _bulletItem(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: AppTheme.body(14, color: AppTheme.textSecondary))),
          ],
        ),
      );
}
