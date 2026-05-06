import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/resource.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class ResourceTypeBadge extends StatelessWidget {
  final ResourceType type;
  const ResourceTypeBadge({super.key, required this.type});

  Color get _color {
    switch (type) {
      case ResourceType.document: return AppTheme.accent;
      case ResourceType.video: return AppTheme.danger;
      case ResourceType.link: return AppTheme.accentAlt;
      case ResourceType.book: return AppTheme.warning;
      case ResourceType.software: return AppTheme.accent;
      case ResourceType.template: return AppTheme.accentAlt;
    }
  }

  String get _label {
    switch (type) {
      case ResourceType.document: return 'Document';
      case ResourceType.video: return 'Video';
      case ResourceType.link: return 'Link';
      case ResourceType.book: return 'Book';
      case ResourceType.software: return 'Software';
      case ResourceType.template: return 'Template';
    }
  }

  @override
  Widget build(BuildContext context) =>
      AppBadge(label: _label, color: _color);
}

class ResourceCard extends StatelessWidget {
  final Resource resource;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const ResourceCard({
    super.key,
    required this.resource,
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
        child: Row(
          children: [
            Container(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.surfaceHigh,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      resource.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.surfaceHigh,
                        child: Icon(resource.typeIcon, color: AppTheme.textSecondary, size: 40),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: ResourceTypeBadge(type: resource.type),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(resource.title, style: AppTheme.heading(14), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ),
                        GestureDetector(
                          onTap: onSave,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              resource.isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                              key: ValueKey(resource.isSaved),
                              color: resource.isSaved ? AppTheme.accent : AppTheme.textSecondary,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(resource.description, style: AppTheme.body(12, color: AppTheme.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: resource.tags.take(3).map((t) => TagChip(label: t)).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(resource.author, style: AppTheme.label(11)),
                        Row(
                          children: [
                            const Icon(Icons.download_rounded, size: 12, color: AppTheme.textSecondary),
                            const SizedBox(width: 2),
                            Text('${resource.downloads}', style: AppTheme.label(11)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
