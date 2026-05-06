import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/talk.dart';
import '../data/talks_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../widgets/talk_widgets.dart';
import 'talk_detail_screen.dart';

class TalksListingScreen extends StatefulWidget {
  const TalksListingScreen({super.key});

  @override
  State<TalksListingScreen> createState() => _TalksListingScreenState();
}

class _TalksListingScreenState extends State<TalksListingScreen> {
  late List<Talk> _talks;
  late List<Talk> _filtered;
  final _searchCtrl = TextEditingController();
  bool _savedOnly = false;
  String _selectedTopic = 'All';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _talks = List.from(TalksData.talks);
    _filtered = List.from(_talks);
    _searchCtrl.addListener(_filter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _talks.where((t) {
        final matchesSearch = q.isEmpty ||
            t.title.toLowerCase().contains(q) ||
            t.speaker.toLowerCase().contains(q) ||
            t.tags.any((tag) => tag.toLowerCase().contains(q));
        final matchesSaved = !_savedOnly || t.isSaved;
        final matchesTopic = _selectedTopic == 'All' || t.tags.contains(_selectedTopic);
        return matchesSearch && matchesSaved && matchesTopic;
      }).toList();
    });
  }

  void _toggleSave(String id) {
    setState(() {
      _talks = _talks.map((t) => t.id == id ? t.copyWith(isSaved: !t.isSaved) : t).toList();
    });
    _filter();
  }

  int get _savedCount => _talks.where((t) => t.isSaved).length;

  Talk? get _featuredTalk => _talks.firstWhere((t) => t.isFeatured, orElse: () => _talks.first);

  List<Talk> get _trendingTalks => _talks.where((t) => t.isTrending).toList();

  List<Talk> get _newestTalks => List.from(_talks)..sort((a, b) => b.date.compareTo(a.date));

  void _surpriseMe() {
    final random = Random();
    final randomTalk = _talks[random.nextInt(_talks.length)];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TalkDetailScreen(
          talk: randomTalk,
          onSave: () => _toggleSave(randomTalk.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _appBar(),
          if (_featuredTalk != null) _heroSection(),
          _topicsRow(),
          _surpriseMeButton(),
          _sectionHeader('Trending Now'),
          _horizontalList(_trendingTalks),
          _sectionHeader('Newest Releases'),
          _horizontalList(_newestTalks),
          _sectionHeader('Curated Playlists'),
          _playlistsSection(),
          _sectionHeader('All Talks'),
          _list(),
        ],
      ),
    );
  }

  Widget _appBar() => SliverAppBar(
        expandedHeight: 100,
        pinned: true,
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  _savedOnly ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                  size: 26,
                ),
                color: _savedOnly ? AppTheme.accent : AppTheme.textSecondary,
                onPressed: () {
                  setState(() => _savedOnly = !_savedOnly);
                  _filter();
                },
              ),
              if (_savedCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
                    child: Center(
                      child: Text('$_savedCount',
                          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
            color: AppTheme.accent,
            onPressed: _showUploadDialog,
          ),
        ],
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
                          label: '● NUST Talks',
                          color: AppTheme.accentAlt,
                          textColor: AppTheme.accentAlt,
                        ),
                        const SizedBox(height: 10),
                        Text('Ideas Worth Spreading', style: AppTheme.heading(24)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _heroSection() {
    final talk = _featuredTalk!;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TalkDetailScreen(
                talk: talk,
                onSave: () => _toggleSave(talk.id),
              ),
            ),
          ),
          child: AppCard(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: CachedNetworkImage(
                        imageUrl: talk.thumbnailUrl,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Talk of the Day', style: AppTheme.label(12, color: Colors.white, weight: FontWeight.w700)),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(talk.title, style: AppTheme.heading(22)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.person_outline_rounded, color: AppTheme.textSecondary, size: 18),
                          const SizedBox(width: 8),
                          Text(talk.speaker, style: AppTheme.label(15, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topicsRow() => SliverToBoxAdapter(
        child: SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: TalksData.topics.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => FilterPill(
              label: TalksData.topics[i],
              selected: _selectedTopic == TalksData.topics[i],
              onTap: () {
                setState(() => _selectedTopic = TalksData.topics[i]);
                _filter();
              },
            ),
          ),
        ),
      );

  Widget _surpriseMeButton() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: GestureDetector(
            onTap: _surpriseMe,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.accent, Color(0xFF8B83FF)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shuffle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text('Surprise Me', style: AppTheme.label(16, color: Colors.white, weight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _sectionHeader(String title) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Text(title, style: AppTheme.heading(20)),
        ),
      );

  Widget _horizontalList(List<Talk> talks) => SliverToBoxAdapter(
        child: SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: talks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) => SizedBox(
              width: 280,
              child: TalkCard(
                talk: talks[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TalkDetailScreen(
                      talk: talks[i],
                      onSave: () => _toggleSave(talks[i].id),
                    ),
                  ),
                ),
                onSave: () => _toggleSave(talks[i].id),
              ),
            ),
          ),
        ),
      );

  Widget _playlistsSection() => SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: TalksData.curatedPlaylists.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) {
              final playlist = TalksData.curatedPlaylists[i];
              return SizedBox(
                width: 220,
                child: AppCard(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: playlist['thumbnailUrl'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(playlist['title'], style: AppTheme.heading(16), maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            Text('${playlist['talkCount']} talks', style: AppTheme.label(12, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

  Widget _list() {
    if (_filtered.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyState(
          icon: Icons.search_off_rounded,
          title: 'No talks found',
          subtitle: 'Try adjusting your search or filters',
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final talk = _filtered[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TalkCard(
                talk: talk,
                onTap: () => Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => TalkDetailScreen(
                      talk: talk,
                      onSave: () => _toggleSave(talk.id),
                    ),
                  ),
                ),
                onSave: () => _toggleSave(talk.id),
              ),
            );
          },
          childCount: _filtered.length,
        ),
      ),
    );
  }

  Future<void> _showUploadDialog() async {
    final formKey = GlobalKey<FormState>();
    String title = '';
    String speaker = '';
    String description = '';
    String tagsInput = '';
    String? videoPath;

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Upload New Talk'),
          backgroundColor: AppTheme.surface,
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    style: AppTheme.body(14),
                    validator: (v) => (v?.isEmpty ?? true) ? 'Please enter a title' : null,
                    onSaved: (v) => title = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Speaker'),
                    style: AppTheme.body(14),
                    validator: (v) => (v?.isEmpty ?? true) ? 'Please enter a speaker' : null,
                    onSaved: (v) => speaker = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    style: AppTheme.body(14),
                    maxLines: 3,
                    validator: (v) => (v?.isEmpty ?? true) ? 'Please enter a description' : null,
                    onSaved: (v) => description = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tags (comma separated)',
                      hintText: 'Technology, AI, Africa',
                    ),
                    style: AppTheme.body(14),
                    onSaved: (v) => tagsInput = v ?? '',
                  ),
                  const SizedBox(height: 20),
                  if (videoPath != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.video_library_rounded, color: AppTheme.accent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              videoPath!.split(RegExp(r'[/\\]')).last,
                              style: AppTheme.label(13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    AppButton(
                      label: 'Select Video File',
                      icon: Icons.upload_file_rounded,
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.video,
                        );
                        if (result != null && result.files.single.path != null) {
                          setDialogState(() {
                            videoPath = result.files.single.path;
                          });
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel', style: AppTheme.label(14, color: AppTheme.textSecondary)),
            ),
            TextButton(
              onPressed: videoPath == null
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        final tags = tagsInput
                            .split(',')
                            .map((t) => t.trim())
                            .where((t) => t.isNotEmpty)
                            .toList();

                        final newTalk = Talk(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: title,
                          speaker: speaker,
                          description: description,
                          thumbnailUrl: 'https://images.unsplash.com/photo-1478737270239-2f02b77fc618?w=600&h=400&fit=crop',
                          videoUrl: '',
                          localVideoPath: videoPath,
                          duration: '00:00',
                          date: DateTime.now(),
                          tags: tags.isEmpty ? ['Custom'] : tags,
                        );

                        setState(() {
                          _talks.insert(0, newTalk);
                          _filtered.insert(0, newTalk);
                        });

                        Navigator.of(dialogContext).pop();
                      }
                    },
              child: Text('Upload', style: AppTheme.label(14, color: AppTheme.accent, weight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
