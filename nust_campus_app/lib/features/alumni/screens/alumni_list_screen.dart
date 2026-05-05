// features/alumni/screens/alumni_list_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../data/alumni_data.dart';
import '../models/alumni.dart';
import '../widgets/alumni_widgets.dart';
import 'alumni_detail_screen.dart';

class AlumniListScreen extends StatefulWidget {
  const AlumniListScreen({super.key});

  @override
  State<AlumniListScreen> createState() => _AlumniListScreenState();
}

class _AlumniListScreenState extends State<AlumniListScreen> {
  late List<Alumni> _alumni;
  late List<Alumni> _filtered;
  final _searchCtrl = TextEditingController();

  String _selectedYear = 'All';
  static const _years = ['All', '2023', '2022', '2021', '2020', '2019', '2018', '2016'];

  @override
  void initState() {
    super.initState();
    _alumni = List.from(AlumniData.alumniList);
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
            a.profession.toLowerCase().contains(q);
        final yearMatch = _selectedYear == 'All' || a.graduationYear.toString() == _selectedYear;
        return search && yearMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topMentors = _alumni.where((a) => a.isTopMentor).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _appBar(),
          if (_searchCtrl.text.isEmpty && _selectedYear == 'All') _featuredSection(topMentors),
          _searchBar(),
          _filterRow(),
          _listTitle(),
          _list(),
        ],
      ),
    );
  }

  Widget _appBar() => SliverAppBar(
        expandedHeight: 110,
        pinned: true,
        backgroundColor: AppTheme.background,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          background: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBadge(
                    label: '● NUST Community',
                    color: AppTheme.accent,
                    textColor: AppTheme.accent,
                  ),
                  const SizedBox(height: 10),
                  Text('Alumni Network', style: AppTheme.heading(24)),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _featuredSection(List<Alumni> mentors) => SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text('Featured Mentors', style: AppTheme.heading(18)),
            ),
            SizedBox(
              height: 160,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: mentors.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (ctx, i) {
                  final mentor = mentors[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AlumniDetailScreen(alumni: mentor)),
                    ),
                    child: Container(
                      width: 140,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceHigh,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppTheme.accent.withOpacity(0.2),
                            child: Text(
                              mentor.name.isNotEmpty ? mentor.name[0].toUpperCase() : '?',
                              style: AppTheme.heading(24).copyWith(color: AppTheme.accent),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            mentor.name,
                            style: AppTheme.body(14).copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mentor.company,
                            style: AppTheme.label(12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );

  Widget _searchBar() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            style: AppTheme.body(14),
            decoration: InputDecoration(
              hintText: 'Search by name, company, or profession...',
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

  Widget _filterRow() => SliverToBoxAdapter(
        child: SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _years.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => FilterPill(
              label: _years[i] == 'All' ? 'All Classes' : 'Class of ${_years[i]}',
              selected: _selectedYear == _years[i],
              onTap: () {
                setState(() => _selectedYear = _years[i]);
                _filter();
              },
            ),
          ),
        ),
      );

  Widget _listTitle() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            '${_filtered.length} Alumni Found',
            style: AppTheme.label(14),
          ),
        ),
      );

  Widget _list() {
    if (_filtered.isEmpty) {
      return SliverFillRemaining(
        child: EmptyState(
          icon: Icons.person_off_rounded,
          title: 'No alumni found',
          subtitle: 'Try adjusting your search criteria',
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final alumni = _filtered[i];
            return AlumniCard(
              alumni: alumni,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AlumniDetailScreen(alumni: alumni)),
              ),
            );
          },
          childCount: _filtered.length,
        ),
      ),
    );
  }
}
