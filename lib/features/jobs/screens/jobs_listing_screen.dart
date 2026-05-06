// features/jobs/screens/jobs_listing_screen.dart
import 'package:flutter/material.dart';
import '../models/job.dart';
import '../data/jobs_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../widgets/job_widgets.dart';
import 'job_detail_screen.dart';

class JobsListingScreen extends StatefulWidget {
  const JobsListingScreen({super.key});

  @override
  State<JobsListingScreen> createState() => _JobsListingScreenState();
}

class _JobsListingScreenState extends State<JobsListingScreen> {
  late List<Job> _jobs;
  late List<Job> _filtered;
  final _searchCtrl = TextEditingController();

  String _type     = 'All';
  String _category = 'All';
  String _sortBy   = 'Recent';
  bool _bookmarksOnly = false;

  static const _types      = ['All', 'Internship', 'Full-Time', 'Part-Time', 'Remote'];
  static const _categories = ['All', 'IT & Software', 'Engineering', 'Business', 'Design', 'Science', 'Finance'];
  static const _sortOpts   = ['Recent', 'Deadline', 'Applicants'];

  @override
  void initState() {
    super.initState();
    _jobs = List.from(JobsData.jobs);
    _filtered = List.from(_jobs);
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
      _filtered = _jobs.where((j) {
        final search = q.isEmpty ||
            j.title.toLowerCase().contains(q) ||
            j.company.toLowerCase().contains(q) ||
            j.skills.any((s) => s.toLowerCase().contains(q));
        final type     = _type == 'All'     || j.typeLabel == _type;
        final category = _category == 'All' || j.categoryLabel == _category;
        final saved    = !_bookmarksOnly    || j.isBookmarked;
        return search && type && category && saved;
      }).toList();

      if (_sortBy == 'Recent')     _filtered.sort((a, b) => b.postedDate.compareTo(a.postedDate));
      if (_sortBy == 'Deadline')   _filtered.sort((a, b) => a.deadline.compareTo(b.deadline));
      if (_sortBy == 'Applicants') _filtered.sort((a, b) => a.applicants.compareTo(b.applicants));
    });
  }

  void _toggleBookmark(String id) {
    setState(() {
      _jobs = _jobs.map((j) => j.id == id ? j.copyWith(isBookmarked: !j.isBookmarked) : j).toList();
    });
    _filter();
  }

  int get _savedCount => _jobs.where((j) => j.isBookmarked).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _appBar(),
          _statsRow(),
          _searchBar(),
          _filterRow(_types, _type,         (v) { setState(() => _type = v);     _filter(); }),
          _filterRow(_categories, _category, (v) { setState(() => _category = v); _filter(); }),
          _sortBar(),
          _list(),
        ],
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────
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
                          label: '● NUST Career Hub',
                          color: AppTheme.accentAlt,
                          textColor: AppTheme.accentAlt,
                        ),
                        const SizedBox(height: 10),
                        Text('Jobs & Internships', style: AppTheme.heading(24)),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          _bookmarksOnly ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                          color: _bookmarksOnly ? AppTheme.accent : AppTheme.textSecondary,
                        ),
                        onPressed: () { setState(() => _bookmarksOnly = !_bookmarksOnly); _filter(); },
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

  // ── Stats ──────────────────────────────────────────────────
  Widget _statsRow() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              StatsCard(value: '${_jobs.length}', label: 'Listings',     icon: Icons.work_outline_rounded,          color: AppTheme.accent),
              const SizedBox(width: 8),
              StatsCard(value: '${_jobs.where((j) => j.type == JobType.internship).length}', label: 'Internships', icon: Icons.school_outlined,                color: AppTheme.danger),
              const SizedBox(width: 8),
              StatsCard(value: '${_jobs.where((j) => j.type == JobType.remote).length}',     label: 'Remote',      icon: Icons.wifi_rounded,                  color: AppTheme.accentAlt),
              const SizedBox(width: 8),
              StatsCard(value: '${_jobs.where((j) => j.type == JobType.fullTime).length}',   label: 'Full-Time',   icon: Icons.business_center_outlined,      color: AppTheme.warning),
            ],
          ),
        ),
      );

  // ── Search ─────────────────────────────────────────────────
  Widget _searchBar() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            style: AppTheme.body(14),
            decoration: InputDecoration(
              hintText: 'Search jobs, companies, skills...',
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

  // ── Filter Row ─────────────────────────────────────────────
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

  // ── Sort Bar ───────────────────────────────────────────────
  Widget _sortBar() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            children: [
              Text(
                '${_filtered.length} result${_filtered.length == 1 ? '' : 's'}',
                style: AppTheme.label(14),
              ),
              if (_bookmarksOnly) ...[
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

  // ── List ───────────────────────────────────────────────────
  Widget _list() {
    if (_filtered.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyState(
          icon: Icons.search_off_rounded,
          title: 'No jobs found',
          subtitle: 'Try adjusting your search or filters',
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final job = _filtered[i];
            return JobCard(
              job: job,
              onBookmark: () => _toggleBookmark(job.id),
              onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => JobDetailScreen(
                    job: job,
                    onBookmark: () => _toggleBookmark(job.id),
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
