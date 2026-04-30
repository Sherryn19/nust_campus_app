// features/jobs/models/job.dart
enum JobType { fullTime, partTime, internship, remote }

enum JobCategory {
  engineering, business, design, it, science, education, finance, healthcare,
}

class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final String logoUrl;
  final JobType type;
  final JobCategory category;
  final String salary;
  final DateTime postedDate;
  final DateTime deadline;
  final List<String> skills;
  final List<String> responsibilities;
  final List<String> requirements;
  final bool isBookmarked;
  final String companyWebsite;
  final String applicationLink;
  final int applicants;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.logoUrl,
    required this.type,
    required this.category,
    required this.salary,
    required this.postedDate,
    required this.deadline,
    required this.skills,
    required this.responsibilities,
    required this.requirements,
    this.isBookmarked = false,
    required this.companyWebsite,
    required this.applicationLink,
    required this.applicants,
  });

  Job copyWith({bool? isBookmarked}) => Job(
        id: id, title: title, company: company, location: location,
        description: description, logoUrl: logoUrl, type: type,
        category: category, salary: salary, postedDate: postedDate,
        deadline: deadline, skills: skills, responsibilities: responsibilities,
        requirements: requirements, companyWebsite: companyWebsite,
        applicationLink: applicationLink, applicants: applicants,
        isBookmarked: isBookmarked ?? this.isBookmarked,
      );

  String get typeLabel {
    switch (type) {
      case JobType.fullTime:   return 'Full-Time';
      case JobType.partTime:   return 'Part-Time';
      case JobType.internship: return 'Internship';
      case JobType.remote:     return 'Remote';
    }
  }

  String get categoryLabel {
    switch (category) {
      case JobCategory.engineering: return 'Engineering';
      case JobCategory.business:    return 'Business';
      case JobCategory.design:      return 'Design';
      case JobCategory.it:          return 'IT & Software';
      case JobCategory.science:     return 'Science';
      case JobCategory.education:   return 'Education';
      case JobCategory.finance:     return 'Finance';
      case JobCategory.healthcare:  return 'Healthcare';
    }
  }
}
