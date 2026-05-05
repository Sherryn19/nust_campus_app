// features/alumni/models/alumni.dart

class Alumni {
  final String id;
  final String name;
  final String? imageUrl;
  final String profession;
  final String company;
  final int graduationYear;
  final String bio;
  final List<String> careerPath;
  final bool isTopMentor;
  final String linkedinUrl;
  final String email;

  const Alumni({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.profession,
    required this.company,
    required this.graduationYear,
    required this.bio,
    this.careerPath = const [],
    this.isTopMentor = false,
    required this.linkedinUrl,
    required this.email,
  });
}
