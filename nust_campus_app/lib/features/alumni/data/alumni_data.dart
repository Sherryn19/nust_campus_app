// features/alumni/data/alumni_data.dart
import '../models/alumni.dart';

class AlumniData {
  static const List<Alumni> alumniList = [
    Alumni(
      id: 'a1',
      name: 'Nyasha',
      profession: 'Senior Software Engineer',
      company: 'Google',
      graduationYear: 2018,
      bio: 'Passionate about building scalable backend systems. Nyasha has been a key contributor to various open-source projects and regularly mentors young engineers.',
      careerPath: [
        'Junior Developer at TechStart (2018-2020)',
        'Software Engineer at Amazon (2020-2022)',
        'Senior Software Engineer at Google (2022-Present)'
      ],
      isTopMentor: true,
      linkedinUrl: 'https://linkedin.com/in/placeholder',
      email: 'nyasha@example.com',
    ),
    Alumni(
      id: 'a2',
      name: 'Tinashe',
      profession: 'Product Manager',
      company: 'Microsoft',
      graduationYear: 2016,
      bio: 'Bridging the gap between engineering and business. Tinashe loves creating user-centric products and has led several successful product launches.',
      careerPath: [
        'Business Analyst at Deloitte (2016-2019)',
        'Product Manager at Microsoft (2019-Present)'
      ],
      isTopMentor: false,
      linkedinUrl: 'https://linkedin.com/in/placeholder',
      email: 'tinashe@example.com',
    ),
    Alumni(
      id: 'a3',
      name: 'Talent',
      profession: 'Data Scientist',
      company: 'DeepMind',
      graduationYear: 2019,
      bio: 'Specializing in generative AI and deep learning. Talent completed a PhD recently and is now working on cutting-edge AI models.',
      careerPath: [
        'PhD Researcher at MIT (2019-2023)',
        'Data Scientist at DeepMind (2023-Present)'
      ],
      isTopMentor: true,
      linkedinUrl: 'https://linkedin.com/in/placeholder',
      email: 'talent@example.com',
    ),
    Alumni(
      id: 'a4',
      name: 'Phineas',
      profession: 'UX Designer',
      company: 'Spotify',
      graduationYear: 2020,
      bio: 'Designing delightful audio experiences. Phineas is an advocate for accessibility in design and regularly speaks at design conferences.',
      careerPath: [
        'UI/UX Intern at Meta (2019)',
        'Product Designer at StartupInc (2020-2022)',
        'UX Designer at Spotify (2022-Present)'
      ],
      isTopMentor: false,
      linkedinUrl: 'https://linkedin.com/in/placeholder',
      email: 'phineas@example.com',
    ),
    Alumni(
      id: 'a5',
      name: 'Nenyasha Tawanda',
      profession: 'Financial Analyst',
      company: 'Goldman Sachs',
      graduationYear: 2021,
      bio: 'Expert in quantitative analysis and market trends. Nenyasha helps advise tech startups on financial strategies.',
      careerPath: [
        'Investment Banking Intern (2020)',
        'Financial Analyst at Goldman Sachs (2021-Present)'
      ],
      isTopMentor: false,
      linkedinUrl: 'https://linkedin.com/in/placeholder',
      email: 'nenyasha@example.com',
    ),
    Alumni(
      id: 'a6',
      name: 'Prince',
      profession: 'Security Engineer',
      company: 'Cloudflare',
      graduationYear: 2022,
      bio: 'Focused on network security and cryptography. Prince helps secure web infrastructure for millions of users worldwide.',
      careerPath: [
        'Security Analyst Intern (2021)',
        'Security Engineer at Cloudflare (2022-Present)'
      ],
      isTopMentor: true,
      linkedinUrl: 'https://linkedin.com/in/placeholder',
      email: 'prince@example.com',
    ),
    Alumni(
      id: 'a7',
      name: 'Brooklyn',
      profession: 'DevOps Engineer',
      company: 'AWS',
      graduationYear: 2017,
      bio: 'Passionate about automation, CI/CD, and cloud infrastructure. Brooklyn has architected deployments for enterprise clients.',
      careerPath: [
        'Systems Administrator (2017-2019)',
        'Cloud Architect (2019-2021)',
        'DevOps Engineer at AWS (2021-Present)'
      ],
      isTopMentor: false,
      linkedinUrl: 'https://linkedin.com/in/placeholder',
      email: 'brooklyn@example.com',
    ),
  ];
}
