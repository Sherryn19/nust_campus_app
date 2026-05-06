import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class EventTypeBadge extends StatelessWidget {
  final EventType type;
  const EventTypeBadge({super.key, required this.type});

  Color get _color {
    switch (type) {
      case EventType.workshop: return AppTheme.accent;
      case EventType.seminar: return AppTheme.accentAlt;
      case EventType.conference: return AppTheme.warning;
      case EventType.social: return AppTheme.danger;
      case EventType.sports: return AppTheme.accent;
      case EventType.career: return AppTheme.accent;
    }
  }

  String get _label {
    switch (type) {
      case EventType.workshop: return 'Workshop';
      case EventType.seminar: return 'Seminar';
      case EventType.conference: return 'Conference';
      case EventType.social: return 'Social';
      case EventType.sports: return 'Sports';
      case EventType.career: return 'Career';
    }
  }

  @override
  Widget build(BuildContext context) =>
      AppBadge(label: _label, color: _color);
}

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const EventCard({
    super.key,
    required this.event,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  child: Image.network(
                    event.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160,
                      width: double.infinity,
                      color: AppTheme.surfaceHigh,
                      child: const Icon(Icons.event_rounded, color: AppTheme.textSecondary, size: 48),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: EventTypeBadge(type: event.type),
                ),
                if (event.isFeatured)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: const AppBadge(label: 'Featured', color: AppTheme.accent),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(event.title, style: AppTheme.heading(16)),
                      ),
                      GestureDetector(
                        onTap: onSave,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            event.isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                            key: ValueKey(event.isSaved),
                            color: event.isSaved ? AppTheme.accent : AppTheme.textSecondary,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(DateFormat('d MMM yyyy').format(event.date), style: AppTheme.label(12)),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time_outlined, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text('${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}', style: AppTheme.label(12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(event.location, style: AppTheme.label(12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: event.tags.map((t) => TagChip(label: t)).toList(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${event.registeredCount}/${event.capacity} registered', style: AppTheme.label(12)),
                        Text('${((event.registeredCount / event.capacity) * 100).toStringAsFixed(0)}%', style: AppTheme.label(12, color: AppTheme.accent, weight: FontWeight.w700)),
                      ],
                    ),
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
