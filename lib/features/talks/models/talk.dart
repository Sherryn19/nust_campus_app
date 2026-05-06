class Talk {
  final String id;
  final String title;
  final String speaker;
  final String speakerBio;
  final String speakerImageUrl;
  final String description;
  final String whyItMatters;
  final String thumbnailUrl;
  final String videoUrl;
  final String? localVideoPath;
  final String duration;
  final DateTime date;
  final List<String> tags;
  final bool isSaved;
  final int views;
  final bool isFeatured;
  final bool isTrending;
  final List<TalkTranscriptLine>? transcript;
  final List<FurtherReadingItem>? furtherReading;
  final List<String>? relatedTalkIds;

  const Talk({
    required this.id,
    required this.title,
    required this.speaker,
    this.speakerBio = '',
    this.speakerImageUrl = '',
    required this.description,
    this.whyItMatters = '',
    required this.thumbnailUrl,
    required this.videoUrl,
    this.localVideoPath,
    required this.duration,
    required this.date,
    required this.tags,
    this.isSaved = false,
    this.views = 0,
    this.isFeatured = false,
    this.isTrending = false,
    this.transcript,
    this.furtherReading,
    this.relatedTalkIds,
  });

  Talk copyWith({bool? isSaved}) => Talk(
        id: id,
        title: title,
        speaker: speaker,
        speakerBio: speakerBio,
        speakerImageUrl: speakerImageUrl,
        description: description,
        whyItMatters: whyItMatters,
        thumbnailUrl: thumbnailUrl,
        videoUrl: videoUrl,
        localVideoPath: localVideoPath,
        duration: duration,
        date: date,
        tags: tags,
        isSaved: isSaved ?? this.isSaved,
        views: views,
        isFeatured: isFeatured,
        isTrending: isTrending,
        transcript: transcript,
        furtherReading: furtherReading,
        relatedTalkIds: relatedTalkIds,
      );
}

class TalkTranscriptLine {
  final String text;
  final Duration timestamp;

  const TalkTranscriptLine({
    required this.text,
    required this.timestamp,
  });
}

class FurtherReadingItem {
  final String title;
  final String author;
  final String url;

  const FurtherReadingItem({
    required this.title,
    required this.author,
    required this.url,
  });
}
