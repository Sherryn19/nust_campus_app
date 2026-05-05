// features/alumni/screens/alumni_detail_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../models/alumni.dart';

class AlumniDetailScreen extends StatelessWidget {
  final Alumni alumni;

  const AlumniDetailScreen({super.key, required this.alumni});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _appBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  const SizedBox(height: 32),
                  _sectionTitle('About'),
                  const SizedBox(height: 12),
                  Text(
                    alumni.bio,
                    style: AppTheme.body(15).copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  if (alumni.careerPath.isNotEmpty) ...[
                    _sectionTitle('Career Path'),
                    const SizedBox(height: 16),
                    _careerPathTimeline(),
                    const SizedBox(height: 32),
                  ],
                  _sectionTitle('Connect'),
                  const SizedBox(height: 16),
                  _connectSection(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppTheme.surfaceHigh,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'alumni_image_${alumni.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: AppTheme.surfaceHigh,
                child: Center(
                  child: Text(
                    alumni.name.isNotEmpty ? alumni.name[0].toUpperCase() : '?',
                    style: AppTheme.heading(120).copyWith(color: AppTheme.accent.withOpacity(0.5)),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppTheme.background.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                alumni.name,
                style: AppTheme.heading(28),
              ),
            ),
            if (alumni.isTopMentor)
              AppBadge(label: 'Top Mentor', color: AppTheme.accentAlt),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${alumni.profession} @ ${alumni.company}',
          style: AppTheme.heading(18).copyWith(color: AppTheme.accent),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.school_rounded, size: 18, color: AppTheme.textSecondary),
            const SizedBox(width: 8),
            Text(
              'Class of ${alumni.graduationYear}',
              style: AppTheme.label(14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.heading(20),
    );
  }

  Widget _careerPathTimeline() {
    return Column(
      children: alumni.careerPath.asMap().entries.map((entry) {
        final i = entry.key;
        final isLast = i == alumni.careerPath.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppTheme.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: AppTheme.cardBorder,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                child: Text(
                  entry.value,
                  style: AppTheme.body(15),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _connectSection(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceHigh,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.email_rounded, color: AppTheme.accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Send a Message', style: AppTheme.heading(16)),
                    const SizedBox(height: 4),
                    Text('Reach out for advice or networking', style: AppTheme.label(13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Connect',
              icon: Icons.handshake_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Connection request sent to ${alumni.name}!'),
                    backgroundColor: AppTheme.accent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
