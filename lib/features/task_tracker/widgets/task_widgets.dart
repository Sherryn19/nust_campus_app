// features/task_tracker/widgets/task_widgets.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../../../core/theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(Task) onUpdate;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.cardBorder, width: 1),
      ),
      child: InkWell(
        onTap: () => _showTaskDetails(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _statusIndicator(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (task.assignedTo != null)
                          Text(
                            'Assigned to: ${task.assignedTo}',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _priorityBadge(),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (task.dueDate != null) ...[
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: task.isOverdue ? AppTheme.warning : AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(task.dueDate!),
                            style: TextStyle(
                              color: task.isOverdue ? AppTheme.warning : AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (task.labels.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: task.labels.take(2).map((label) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                label,
                                style: const TextStyle(
                                  color: AppTheme.accent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusIndicator() {
    Color color;
    String label;

    switch (task.status) {
      case TaskStatus.todo:
        color = AppTheme.textSecondary;
        label = '○';
        break;
      case TaskStatus.inProgress:
        color = AppTheme.accent;
        label = '◐';
        break;
      case TaskStatus.completed:
        color = AppTheme.success;
        label = '✓';
        break;
    }

    return GestureDetector(
      onTap: () => _cycleStatus(),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _priorityBadge() {
    Color color;
    switch (task.priority) {
      case TaskPriority.low:
        color = AppTheme.accentAlt;
        break;
      case TaskPriority.medium:
        color = AppTheme.accent;
        break;
      case TaskPriority.high:
        color = Colors.orange;
        break;
      case TaskPriority.urgent:
        color = AppTheme.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        task.priority.name.capitalize(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _cycleStatus() {
    final nextStatus = switch (task.status) {
      TaskStatus.todo => TaskStatus.inProgress,
      TaskStatus.inProgress => TaskStatus.completed,
      TaskStatus.completed => TaskStatus.todo,
    };

    onUpdate(task.copyWith(status: nextStatus, isCompleted: nextStatus == TaskStatus.completed));
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(DateTime(now.year, now.month, now.day));

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 0) {
      return '${-difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showTaskDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TaskDetailsSheet(
        task: task,
        onUpdate: onUpdate,
      ),
    );
  }
}

class TaskDetailsSheet extends StatefulWidget {
  final Task task;
  final Function(Task) onUpdate;

  const TaskDetailsSheet({
    Key? key,
    required this.task,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<TaskDetailsSheet> createState() => _TaskDetailsSheetState();
}

class _TaskDetailsSheetState extends State<TaskDetailsSheet> {
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          color: AppTheme.surface,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppTheme.surface,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: const Text(
                    'Task Details',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: false,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentTask.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Status', _currentTask.statusLabel),
                      _buildDetailRow('Priority', _currentTask.priorityLabel),
                      if (_currentTask.assignedTo != null)
                        _buildDetailRow('Assigned To', _currentTask.assignedTo!),
                      if (_currentTask.dueDate != null)
                        _buildDetailRow('Due Date', _formatDate(_currentTask.dueDate!)),
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentTask.description,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                      if (_currentTask.labels.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Labels',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: _currentTask.labels.map((label) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                label,
                                style: const TextStyle(
                                  color: AppTheme.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 24),
                      _buildActionButton('Mark as Complete', () {
                        widget.onUpdate(_currentTask.copyWith(
                          isCompleted: !_currentTask.isCompleted,
                          status: !_currentTask.isCompleted ? TaskStatus.completed : TaskStatus.todo,
                        ));
                        Navigator.pop(context);
                      }),
                      const SizedBox(height: 8),
                      _buildActionButton('Close', () => Navigator.pop(context), outlined: true),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap, {bool outlined = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : AppTheme.accent,
          border: outlined ? Border.all(color: AppTheme.accent, width: 1) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: outlined ? AppTheme.accent : AppTheme.surface,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

extension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}
