import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/talk.dart';
import '../data/talks_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../widgets/talk_widgets.dart';

class TalkDetailScreen extends StatefulWidget {
  final Talk talk;
  final VoidCallback? onSave;

  const TalkDetailScreen({
    super.key,
    required this.talk,
    this.onSave,
  });

  @override
  State<TalkDetailScreen> createState() => _TalkDetailScreenState();
}

class _TalkDetailScreenState extends State<TalkDetailScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLiked = false;
  int _likeCount = 0;

  List<Talk> get _relatedTalks {
    if (widget.talk.relatedTalkIds == null) return [];
    return TalksData.talks.where((t) => widget.talk.relatedTalkIds!.contains(t.id)).toList();
  }

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _likeCount = (widget.talk.views / 100).round();
  }

  Future<void> _initializePlayer() async {
    if (widget.talk.localVideoPath != null) {
      _videoPlayerController = VideoPlayerController.file(
        File(widget.talk.localVideoPath!),
      );
    } else {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.talk.videoUrl),
      );
    }

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppTheme.accent,
        handleColor: AppTheme.accent,
        backgroundColor: AppTheme.surfaceHigh,
        bufferedColor: AppTheme.accent.withValues(alpha: 0.4),
      ),
    );

    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.background,
            elevation: 0,
            actions: [
              if (widget.onSave != null)
                IconButton(
                  icon: Icon(
                    widget.talk.isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                    size: 26,
                  ),
                  color: widget.talk.isSaved ? AppTheme.accent : AppTheme.textSecondary,
                  onPressed: widget.onSave,
                ),
              IconButton(
                icon: const Icon(Icons.share_rounded, size: 26),
                color: AppTheme.textSecondary,
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _chewieController != null &&
                      _chewieController!.videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController!)
                  : Container(
                      color: AppTheme.surfaceHigh,
                      child: const Center(
                        child: CircularProgressIndicator(color: AppTheme.accent),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.talk.title,
                    style: AppTheme.heading(24),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.person_outline_rounded, color: AppTheme.textSecondary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        widget.talk.speaker,
                        style: AppTheme.label(15, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.schedule_outlined, color: AppTheme.textSecondary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        widget.talk.duration,
                        style: AppTheme.label(15, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _actionBar(),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.talk.tags.map((tag) => TagChip(label: tag, highlighted: true)).toList(),
                  ),
                  const SizedBox(height: 32),
                  if (widget.talk.whyItMatters.isNotEmpty) ...[
                    const SectionHeader(title: 'Why it Matters'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        widget.talk.whyItMatters,
                        style: AppTheme.body(15),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  const SectionHeader(title: 'About this talk'),
                  const SizedBox(height: 16),
                  Text(
                    widget.talk.description,
                    style: AppTheme.body(15),
                  ),
                  const SizedBox(height: 32),
                  if (widget.talk.transcript != null && widget.talk.transcript!.isNotEmpty) ...[
                    const SectionHeader(title: 'Transcript'),
                    const SizedBox(height: 16),
                    _transcriptSection(),
                    const SizedBox(height: 32),
                  ],
                  const SectionHeader(title: 'About the Speaker'),
                  const SizedBox(height: 16),
                  _speakerSection(),
                  const SizedBox(height: 32),
                  if (widget.talk.furtherReading != null && widget.talk.furtherReading!.isNotEmpty) ...[
                    const SectionHeader(title: 'Further Reading'),
                    const SizedBox(height: 16),
                    _furtherReadingSection(),
                    const SizedBox(height: 32),
                  ],
                  if (_relatedTalks.isNotEmpty) ...[
                    const SectionHeader(title: 'Related Talks'),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
          if (_relatedTalks.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 280,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _relatedTalks.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, i) => SizedBox(
                    width: 280,
                    child: TalkCard(
                      talk: _relatedTalks[i],
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TalkDetailScreen(
                              talk: _relatedTalks[i],
                              onSave: widget.onSave,
                            ),
                          ),
                        );
                      },
                      onSave: widget.onSave ?? () {},
                    ),
                  ),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _actionBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionItem(
          icon: _isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          label: '$_likeCount',
          color: _isLiked ? AppTheme.danger : AppTheme.textSecondary,
          onTap: _toggleLike,
        ),
        _actionItem(
          icon: Icons.bookmark_outline_rounded,
          label: 'Save',
          color: AppTheme.textSecondary,
          onTap: widget.onSave,
        ),
        _actionItem(
          icon: Icons.share_outlined,
          label: 'Share',
          color: AppTheme.textSecondary,
          onTap: () {},
        ),
        _actionItem(
          icon: Icons.download_outlined,
          label: 'Download',
          color: AppTheme.textSecondary,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _actionItem({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 26, color: color),
          const SizedBox(height: 4),
          Text(label, style: AppTheme.label(12, color: color)),
        ],
      ),
    );
  }

  Widget _transcriptSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.talk.transcript!.map((line) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                if (_chewieController != null) {
                  _chewieController!.seekTo(line.timestamp);
                  _chewieController!.play();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceHigh,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _formatDuration(line.timestamp),
                      style: AppTheme.label(11, color: AppTheme.accent),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      line.text,
                      style: AppTheme.body(14, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  Widget _speakerSection() {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.talk.speakerImageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.talk.speakerImageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppTheme.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: AppTheme.textSecondary, size: 32),
            ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.talk.speaker, style: AppTheme.heading(18)),
                const SizedBox(height: 4),
                if (widget.talk.speakerBio.isNotEmpty)
                  Text(
                    widget.talk.speakerBio,
                    style: AppTheme.body(13, color: AppTheme.textSecondary),
                  ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'More talks by ${widget.talk.speaker.split(' ').first}',
                    style: AppTheme.label(13, color: AppTheme.accent, weight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _furtherReadingSection() {
    return Column(
      children: widget.talk.furtherReading!.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => _launchUrl(item.url),
            child: AppCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceHigh,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.menu_book_rounded, color: AppTheme.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: AppTheme.body(14)),
                        const SizedBox(height: 4),
                        Text(item.author, style: AppTheme.label(12, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.open_in_new_rounded, color: AppTheme.accent, size: 18),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
