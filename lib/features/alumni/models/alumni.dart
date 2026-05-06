enum AlumniCategory {
  engineering, business, science, education, healthcare, technology,
}

class Alumni {
  final String id;
  final String name;
  final String photoUrl;
  final int graduationYear;
  final String program;
  final String currentRole;
  final String company;
  final String location;
  final String bio;
  final AlumniCategory category;
  final List<String> skills;
  final String linkedinUrl;
  final String? twitterUrl;
  final String? email;
  final bool isFeatured;
  final bool isSaved;
  final DateTime joinedDate;

  const Alumni({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.graduationYear,
    required this.program,
    required this.currentRole,
    required this.company,
    required this.location,
    required this.bio,
    required this.category,
    required this.skills,
    required this.linkedinUrl,
    this.twitterUrl,
    this.email,
    this.isFeatured = false,
    this.isSaved = false,
    required this.joinedDate,
  });

  Alumni copyWith({bool? isSaved}) => Alumni(
        id: id,
        name: name,
        photoUrl: photoUrl,
        graduationYear: graduationYear,
        program: program,
        currentRole: currentRole,
        company: company,
        location: location,
        bio: bio,
        category: category,
        skills: skills,
        linkedinUrl: linkedinUrl,
        twitterUrl: twitterUrl,
        email: email,
        isFeatured: isFeatured,
        isSaved: isSaved ?? this.isSaved,
        joinedDate: joinedDate,
      );

  String get categoryLabel {
    switch (category) {
      case AlumniCategory.engineering: return 'Engineering';
      case AlumniCategory.business: return 'Business';
      case AlumniCategory.science: return 'Science';
      case AlumniCategory.education: return 'Education';
      case AlumniCategory.healthcare: return 'Healthcare';
      case AlumniCategory.technology: return 'Technology';
    }
  }
}
