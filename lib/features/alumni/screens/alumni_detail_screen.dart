import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/alumni.dart';
import '../widgets/alumni_widgets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class AlumniDetailScreen extends StatelessWidget {
  final Alumni alumni;
  final VoidCallback onSave;

  const AlumniDetailScreen({
    super.key,
    required this.alumni,
    required this.onSave,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
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
                    alumni.isSaved ? Icons.star_rounded : Icons.star_outline_rounded,
                    key: ValueKey(alumni.isSaved),
                    color: alumni.isSaved ? AppTheme.accent : AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
                onPressed: onSave,
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
                            AlumniPhoto(photoUrl: alumni.photoUrl, size: 80),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (alumni.isFeatured)
                                    const AppBadge(label: 'Featured Alumni', color: AppTheme.accent),
                                  const SizedBox(height: 8),
                                  Text(alumni.name, style: AppTheme.heading(22)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${alumni.currentRole} at ${alumni.company}',
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCard(
                    child: Row(
                      children: [
                        _infoItem(Icons.location_on_outlined, alumni.location),
                        _divider(),
                        _infoItem(Icons.school_outlined, 'Class of ${alumni.graduationYear}', color: AppTheme.accentAlt),
                        _divider(),
                        _infoItem(Icons.work_outline_rounded, alumni.program),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('About', style: AppTheme.heading(18)),
                  const SizedBox(height: 10),
                  Text(alumni.bio, style: AppTheme.body(14, color: AppTheme.textSecondary)),
                  const SizedBox(height: 24),
                  Text('Skills', style: AppTheme.heading(18)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: alumni.skills.map((s) => TagChip(label: s, highlighted: true)).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text('Connect', style: AppTheme.heading(18)),
                  const SizedBox(height: 10),
                  AppCard(
                    child: Column(
                      children: [
                        _connectItem(Icons.linked_camera, 'LinkedIn', alumni.linkedinUrl, () => _launchUrl(alumni.linkedinUrl)),
                        if (alumni.twitterUrl != null) ...[
                          const Divider(height: 1, color: AppTheme.cardBorder),
                          _connectItem(Icons.alternate_email, 'Twitter', alumni.twitterUrl!, () => _launchUrl(alumni.twitterUrl!)),
                        ],
                        if (alumni.email != null) ...[
                          const Divider(height: 1, color: AppTheme.cardBorder),
                          _connectItem(Icons.email_outlined, 'Email', alumni.email!, () => _launchUrl('mailto:${alumni.email}')),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
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

  Widget _connectItem(IconData icon, String label, String url, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.accent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTheme.body(14)),
                  const SizedBox(height: 2),
                  Text(url, style: AppTheme.label(12, color: AppTheme.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }
}
