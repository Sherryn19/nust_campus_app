// features/alumni/widgets/alumni_widgets.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../models/alumni.dart';

class AlumniCard extends StatelessWidget {
  final Alumni alumni;
  final VoidCallback onTap;

  const AlumniCard({
    super.key,
    required this.alumni,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Hero(
              tag: 'alumni_image_${alumni.id}',
              child: CircleAvatar(
                radius: 36,
                backgroundColor: AppTheme.accent.withOpacity(0.2),
                child: Text(
                  alumni.name.isNotEmpty ? alumni.name[0].toUpperCase() : '?',
                  style: AppTheme.heading(28).copyWith(color: AppTheme.accent),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alumni.name,
                          style: AppTheme.heading(18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (alumni.isTopMentor)
                        const Icon(
                          Icons.verified_rounded,
                          color: AppTheme.accentAlt,
                          size: 18,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${alumni.profession} at ${alumni.company}',
                    style: AppTheme.body(14).copyWith(color: AppTheme.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TagChip(label: 'Class of ${alumni.graduationYear}'),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
