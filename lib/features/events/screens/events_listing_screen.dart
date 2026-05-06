import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../data/events_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../widgets/events_widgets.dart';

class EventsListingScreen extends StatefulWidget {
  const EventsListingScreen({super.key});

  @override
  State<EventsListingScreen> createState() => _EventsListingScreenState();
}

class _EventsListingScreenState extends State<EventsListingScreen> {
  late List<Event> _events;
  late List<Event> _filtered;
  final _searchCtrl = TextEditingController();

  String _type = 'All';
  String _sortBy = 'Date';
  bool _savedOnly = false;

  static const _types = ['All', 'Workshop', 'Seminar', 'Conference', 'Social', 'Sports', 'Career'];
  static const _sortOpts = ['Date', 'Popular', 'Alphabetical'];

  @override
  void initState() {
    super.initState();
    _events = List.from(EventsData.events);
    _filtered = List.from(_events);
    _searchCtrl.addListener(_filter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _events.where((e) {
        final search = q.isEmpty ||
            e.title.toLowerCase().contains(q) ||
            e.description.toLowerCase().contains(q) ||
            e.tags.any((t) => t.toLowerCase().contains(q));
        final type = _type == 'All' || e.typeLabel == _type;
        final saved = !_savedOnly || e.isSaved;
        return search && type && saved;
      }).toList();

      if (_sortBy == 'Date') _filtered.sort((a, b) => a.date.compareTo(b.date));
      if (_sortBy == 'Popular') _filtered.sort((a, b) => b.registeredCount.compareTo(a.registeredCount));
      if (_sortBy == 'Alphabetical') _filtered.sort((a, b) => a.title.compareTo(b.title));
    });
  }

  void _toggleSave(String id) {
    setState(() {
      _events = _events.map((e) => e.id == id ? e.copyWith(isSaved: !e.isSaved) : e).toList();
    });
    _filter();
  }

  int get _savedCount => _events.where((e) => e.isSaved).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _appBar(),
          _statsRow(),
          _searchBar(),
          _filterRow(_types, _type, (v) { setState(() => _type = v); _filter(); }),
          _sortBar(),
          _list(),
        ],
      ),
    );
  }

  Widget _appBar() => SliverAppBar(
        expandedHeight: 120,
        pinned: true,
        backgroundColor: AppTheme.background,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          background: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppBadge(
                          label: '● NUST Events',
                          color: AppTheme.accentAlt,
                          textColor: AppTheme.accentAlt,
                        ),
                        const SizedBox(height: 10),
                        Text('Campus Events', style: AppTheme.heading(24)),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          _savedOnly ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                          color: _savedOnly ? AppTheme.accent : AppTheme.textSecondary,
                        ),
                        onPressed: () { setState(() => _savedOnly = !_savedOnly); _filter(); },
                      ),
                      if (_savedCount > 0)
                        Positioned(
                          right: 6, top: 6,
                          child: Container(
                            width: 16, height: 16,
                            decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
                            child: Center(
                              child: Text('$_savedCount',
                                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _statsRow() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              StatsCard(value: '${_events.length}', label: 'Events', icon: Icons.event_outlined, color: AppTheme.accent),
              const SizedBox(width: 8),
              StatsCard(value: '${_events.where((e) => e.isFeatured).length}', label: 'Featured', icon: Icons.star_outline_rounded, color: AppTheme.danger),
              const SizedBox(width: 8),
              StatsCard(value: '${_events.where((e) => e.date.isAfter(DateTime.now())).length}', label: 'Upcoming', icon: Icons.calendar_today_outlined, color: AppTheme.accentAlt),
            ],
          ),
        ),
      );

  Widget _searchBar() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            style: AppTheme.body(14),
            decoration: InputDecoration(
              hintText: 'Search events, organizers, tags...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondary, size: 20),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.textSecondary),
                      onPressed: () => _searchCtrl.clear(),
                    )
                  : null,
            ),
          ),
        ),
      );

  Widget _filterRow(List<String> options, String selected, ValueChanged<String> onSelect) =>
      SliverToBoxAdapter(
        child: SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => FilterPill(
              label: options[i],
              selected: selected == options[i],
              onTap: () => onSelect(options[i]),
            ),
          ),
        ),
      );

  Widget _sortBar() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            children: [
              Text(
                '${_filtered.length} result${_filtered.length == 1 ? '' : 's'}',
                style: AppTheme.label(14),
              ),
              if (_savedOnly) ...[
                const SizedBox(width: 8),
                const AppBadge(label: 'Saved only', color: AppTheme.accent),
              ],
              const Spacer(),
              PopupMenuButton<String>(
                color: AppTheme.surfaceHigh,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (v) { setState(() => _sortBy = v); _filter(); },
                child: Row(children: [
                  const Icon(Icons.sort_rounded, color: AppTheme.textSecondary, size: 18),
                  const SizedBox(width: 4),
                  Text(_sortBy, style: AppTheme.label(13)),
                ]),
                itemBuilder: (_) => _sortOpts.map((s) => PopupMenuItem(
                  value: s,
                  child: Text(s, style: AppTheme.body(13)),
                )).toList(),
              ),
            ],
          ),
        ),
      );

  Widget _list() {
    if (_filtered.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyState(
          icon: Icons.search_off_rounded,
          title: 'No events found',
          subtitle: 'Try adjusting your search or filters',
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final event = _filtered[i];
            return EventCard(
              event: event,
              onSave: () => _toggleSave(event.id),
              onTap: () {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text('${event.title} selected'), backgroundColor: AppTheme.accent),
                );
              },
            );
          },
          childCount: _filtered.length,
        ),
      ),
    );
  }
}
