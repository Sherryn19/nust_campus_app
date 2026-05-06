import '../models/resource.dart';

class ResourcesData {
  static List<Resource> resources = [
    Resource(
      id: '1',
      title: 'Flutter Complete Guide',
      description: 'Comprehensive guide to Flutter development with examples and best practices.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&h=400&fit=crop',
      type: ResourceType.document,
      tags: ['Flutter', 'Mobile Dev', 'Guide'],
      author: 'Dr. Farai Chidyausiku',
      uploadDate: DateTime(2025, 4, 1),
      fileUrl: 'https://example.com/flutter-guide.pdf',
      fileSize: '12.5 MB',
      downloads: 1245,
      isFeatured: true,
    ),
    Resource(
      id: '2',
      title: 'Python for Data Science',
      description: 'Learn Python programming for data science and machine learning applications.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?w=800&h=400&fit=crop',
      type: ResourceType.video,
      tags: ['Python', 'Data Science', 'ML'],
      author: 'Rumbidzai Ncube',
      uploadDate: DateTime(2025, 4, 10),
      fileUrl: 'https://example.com/python-data-science.mp4',
      fileSize: '250 MB',
      downloads: 890,
    ),
    Resource(
      id: '3',
      title: 'Resume Template Pack',
      description: 'Professional resume templates for students and graduates.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=800&h=400&fit=crop',
      type: ResourceType.template,
      tags: ['Resume', 'Career', 'Templates'],
      author: 'NUST Career Services',
      uploadDate: DateTime(2025, 3, 20),
      fileUrl: 'https://example.com/resume-templates.zip',
      fileSize: '5.2 MB',
      downloads: 2340,
      isFeatured: true,
    ),
  ];
}
