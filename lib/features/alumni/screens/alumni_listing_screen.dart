import 'package:flutter/material.dart';
import '../models/alumni.dart';
import '../data/alumni_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../widgets/alumni_widgets.dart';
import 'alumni_detail_screen.dart';

class AlumniListingScreen extends StatefulWidget {
  const AlumniListingScreen({super.key});

  @override
  State<AlumniListingScreen> createState() => _AlumniListingScreenState();
}

class _AlumniListingScreenState extends State<AlumniListingScreen> {
  late List<Alumni> _alumni;
  late List<Alumni> _filtered;
  final _searchCtrl = TextEditingController();

  String _category = 'All';
  String _sortBy = 'Recent';
  bool _savedOnly = false;

  static const _categories = ['All', 'Engineering', 'Business', 'Science', 'Education', 'Healthcare', 'Technology'];
  static const _sortOpts = ['Recent', 'Graduation Year', 'Name'];

  @override
  void initState() {
    super.initState();
    _alumni = List.from(AlumniData.alumni);
    _filtered = List.from(_alumni);
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
      _filtered = _alumni.where((a) {
        final search = q.isEmpty ||
            a.name.toLowerCase().contains(q) ||
            a.company.toLowerCase().contains(q) ||
            a.currentRole.toLowerCase().contains(q) ||
            a.skills.any((s) => s.toLowerCase().contains(q));
        final category = _category == 'All' || a.categoryLabel == _category;
        final saved = !_savedOnly || a.isSaved;
        return search && category && saved;
      }).toList();

      if (_sortBy == 'Recent') _filtered.sort((a, b) => b.joinedDate.compareTo(a.joinedDate));
      if (_sortBy == 'Graduation Year') _filtered.sort((a, b) => b.graduationYear.compareTo(a.graduationYear));
      if (_sortBy == 'Name') _filtered.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void _toggleSave(String id) {
    setState(() {
      _alumni = _alumni.map((a) => a.id == id ? a.copyWith(isSaved: !a.isSaved) : a).toList();
    });
    _filter();
  }

  int get _savedCount => _alumni.where((a) => a.isSaved).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _appBar(),
          _statsRow(),
          _searchBar(),
          _filterRow(_categories, _category, (v) { setState(() => _category = v); _filter(); }),
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
                          label: '● NUST Alumni Network',
                          color: AppTheme.accentAlt,
                          textColor: AppTheme.accentAlt,
                        ),
                        const SizedBox(height: 10),
                        Text('Alumni Updates', style: AppTheme.heading(24)),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          _savedOnly ? Icons.star_rounded : Icons.star_outline_rounded,
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
              StatsCard(value: '${_alumni.length}', label: 'Alumni', icon: Icons.people_outline_rounded, color: AppTheme.accent),
              const SizedBox(width: 8),
              StatsCard(value: '${_alumni.where((a) => a.isFeatured).length}', label: 'Featured', icon: Icons.star_outline_rounded, color: AppTheme.danger),
              const SizedBox(width: 8),
              StatsCard(value: '${_alumni.where((a) => a.graduationYear >= 2020).length}', label: 'Recent Grads', icon: Icons.school_outlined, color: AppTheme.accentAlt),
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
              hintText: 'Search alumni, companies, skills...',
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
          title: 'No alumni found',
          subtitle: 'Try adjusting your search or filters',
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final alumni = _filtered[i];
            return AlumniCard(
              alumni: alumni,
              onSave: () => _toggleSave(alumni.id),
              onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => AlumniDetailScreen(
                    alumni: alumni,
                    onSave: () => _toggleSave(alumni.id),
                  ),
                ),
              ),
            );
          },
          childCount: _filtered.length,
        ),
      ),
    );
  }
}
