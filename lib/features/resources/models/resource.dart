import 'package:flutter/material.dart';

enum ResourceType { document, video, link, book, software, template }

class Resource {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final ResourceType type;
  final List<String> tags;
  final String author;
  final DateTime uploadDate;
  final String fileUrl;
  final String? fileSize;
  final int downloads;
  final bool isFeatured;
  final bool isSaved;

  const Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.type,
    required this.tags,
    required this.author,
    required this.uploadDate,
    required this.fileUrl,
    this.fileSize,
    required this.downloads,
    this.isFeatured = false,
    this.isSaved = false,
  });

  Resource copyWith({bool? isSaved}) => Resource(
        id: id,
        title: title,
        description: description,
        thumbnailUrl: thumbnailUrl,
        type: type,
        tags: tags,
        author: author,
        uploadDate: uploadDate,
        fileUrl: fileUrl,
        fileSize: fileSize,
        downloads: downloads,
        isFeatured: isFeatured,
        isSaved: isSaved ?? this.isSaved,
      );

  String get typeLabel {
    switch (type) {
      case ResourceType.document: return 'Document';
      case ResourceType.video: return 'Video';
      case ResourceType.link: return 'Link';
      case ResourceType.book: return 'Book';
      case ResourceType.software: return 'Software';
      case ResourceType.template: return 'Template';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case ResourceType.document: return Icons.description_rounded;
      case ResourceType.video: return Icons.videocam_rounded;
      case ResourceType.link: return Icons.link_rounded;
      case ResourceType.book: return Icons.menu_book_rounded;
      case ResourceType.software: return Icons.computer_rounded;
      case ResourceType.template: return Icons.insert_drive_file_rounded;
    }
  }
}
