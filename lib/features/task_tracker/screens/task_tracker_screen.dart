// features/task_tracker/screens/task_tracker_screen.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../data/task_data.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/task_widgets.dart';

class TaskTrackerScreen extends StatefulWidget {
  const TaskTrackerScreen({super.key});

  @override
  State<TaskTrackerScreen> createState() => _TaskTrackerScreenState();
}

class _TaskTrackerScreenState extends State<TaskTrackerScreen> {
  late List<Task> _tasks;
  late List<Task> _filtered;
  final _searchCtrl = TextEditingController();
  TaskStatus? _selectedStatus;
  TaskPriority? _selectedPriority;
  String _sortBy = 'dueDate';

  @override
  void initState() {
    super.initState();
    _tasks = List.from(TaskData.tasks);
    _filtered = List.from(_tasks);
    _searchCtrl.addListener(_filter);
    _sortTasks();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _tasks.where((t) {
        final matchesSearch = q.isEmpty ||
            t.title.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q) ||
            t.labels.any((label) => label.toLowerCase().contains(q));
        final matchesStatus = _selectedStatus == null || t.status == _selectedStatus;
        final matchesPriority = _selectedPriority == null || t.priority == _selectedPriority;
        return matchesSearch && matchesStatus && matchesPriority;
      }).toList();
      _sortTasks();
    });
  }

  void _sortTasks() {
    switch (_sortBy) {
      case 'dueDate':
        _filtered.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case 'priority':
        _filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case 'status':
        _filtered.sort((a, b) => a.status.index.compareTo(b.status.index));
        break;
    }
  }

  void _updateTask(Task updatedTask) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
    });
    _filter();
  }

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  int get _totalCount => _tasks.length;
  int get _overdueCount => _tasks.where((t) => t.isOverdue).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _appBar(),
          _statsBar(),
          _searchBar(),
          _filterBar(),
          if (_filtered.isEmpty)
            SliverFillRemaining(
              child: _emptyState(),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => TaskCard(
                  task: _filtered[index],
                  onUpdate: _updateTask,
                ),
                childCount: _filtered.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: const Text(
          'Task Tracker',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
    );
  }

  Widget _statsBar() {
    return SliverToBoxAdapter(
      child: Container(
        color: AppTheme.surface,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _statCard('Total', '$_totalCount', AppTheme.accent),
            const SizedBox(width: 12),
            _statCard('Completed', '$_completedCount', AppTheme.accentAlt),
            const SizedBox(width: 12),
            _statCard('Overdue', '$_overdueCount', AppTheme.warning),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceHigh,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.cardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return SliverToBoxAdapter(
      child: Container(
        color: AppTheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            hintStyle: const TextStyle(color: AppTheme.textSecondary),
            prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.cardBorder),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: AppTheme.cardBackground,
          ),
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
      ),
    );
  }

  Widget _filterBar() {
    return SliverToBoxAdapter(
      child: Container(
        color: AppTheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip('Status', _selectedStatus?.name ?? 'All', () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _statusFilterSheet(),
                );
              }),
              const SizedBox(width: 8),
              _filterChip('Priority', _selectedPriority?.priorityLabel ?? 'All', () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _priorityFilterSheet(),
                );
              }),
              const SizedBox(width: 8),
              _filterChip('Sort', _sortBy.capitalize(), () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _sortFilterSheet(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            Text(
              '$label: $value',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, size: 16, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _statusFilterSheet() {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter by Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _filterOption('All', null, _selectedStatus, (status) {
            setState(() => _selectedStatus = status);
            Navigator.pop(context);
            _filter();
          }),
          ...TaskStatus.values.map((status) => _filterOption(
            status.name.capitalize(),
            status,
            _selectedStatus,
            (value) {
              setState(() => _selectedStatus = value);
              Navigator.pop(context);
              _filter();
            },
          )),
        ],
      ),
    );
  }

  Widget _priorityFilterSheet() {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter by Priority', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _priorityOption('All', null, _selectedPriority, (priority) {
            setState(() => _selectedPriority = priority);
            Navigator.pop(context);
            _filter();
          }),
          ...TaskPriority.values.map((priority) => _priorityOption(
            priority.priorityLabel,
            priority,
            _selectedPriority,
            (value) {
              setState(() => _selectedPriority = value);
              Navigator.pop(context);
              _filter();
            },
          )),
        ],
      ),
    );
  }

  Widget _sortFilterSheet() {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sort by', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _sortOption('Due Date', 'dueDate'),
          _sortOption('Priority', 'priority'),
          _sortOption('Status', 'status'),
        ],
      ),
    );
  }

  Widget _filterOption(
    String label,
    TaskStatus? status,
    TaskStatus? selected,
    Function(TaskStatus?) onTap,
  ) {
    final isSelected = (status == null && selected == null) || status == selected;
    return InkWell(
      onTap: () => onTap(status),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.cardBorder, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textPrimary)),
            if (isSelected)
              const Icon(Icons.check, color: AppTheme.accent),
          ],
        ),
      ),
    );
  }

  Widget _priorityOption(
    String label,
    TaskPriority? priority,
    TaskPriority? selected,
    Function(TaskPriority?) onTap,
  ) {
    final isSelected = (priority == null && selected == null) || priority == selected;
    return InkWell(
      onTap: () => onTap(priority),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.cardBorder, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textPrimary)),
            if (isSelected)
              const Icon(Icons.check, color: AppTheme.accent),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(String label, String value) {
    final isSelected = _sortBy == value;
    return InkWell(
      onTap: () {
        setState(() => _sortBy = value);
        _filter();
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.cardBorder, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textPrimary)),
            if (isSelected)
              const Icon(Icons.check, color: AppTheme.accent),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      color: AppTheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: AppTheme.textSecondary.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            'No tasks found',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filters',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

extension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}

extension on TaskPriority {
  String get priorityLabel {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }
}
