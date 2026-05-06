# NUST Campus App — Group Project

> **Modular Flutter application** for NUST student services.  
> Each group owns one feature module. The shell and shared core are pre-built.

---

## 📁 Project Structure

```
lib/
├── main.dart                          ← App entry point (don't touch)
├── core/
│   ├── theme/
│   │   └── app_theme.dart             ← Shared colours, fonts, ThemeData
│   ├── widgets/
│   │   └── shared_widgets.dart        ← Reusable UI components
│   └── navigation/
│       └── app_navigation.dart        ← ⭐ REGISTER YOUR MODULE HERE
└── features/
    ├── jobs/                          ✅ Group 1 — Career Dev (done)
    │   ├── models/job.dart
    │   ├── data/jobs_data.dart
    │   ├── widgets/job_widgets.dart
    │   └── screens/
    │       ├── jobs_listing_screen.dart
    │       └── job_detail_screen.dart
    ├── alumni/                        🔲 Group 2 — build here
    ├── talks/                         🔲 Group 3 — build here
    └── your_module/                   🔲 Other groups — create your folder
```

---

## ✅ Module Assignments

| # | Module | Group | Status |
|---|--------|-------|--------|
| 1 | Jobs & Internships Listing | Group 1 | ✅ Done |
| 2 | Alumni Network | Group 2 | 🔲 In progress |
| 3 | NUST Talks (TED-style) | Group 3 | 🔲 In progress |
| 4 | _(your module)_ | Group 4 | 🔲 In progress |
| 5 | _(your module)_ | Group 5 | 🔲 In progress |

---

## 🚀 How to Add Your Module (3 steps)

### Step 1 — Create your feature folder

```
lib/features/<your_module>/
    screens/        ← your screens go here
    widgets/        ← your module-specific widgets
    models/         ← your data models
    data/           ← your mock data
```

### Step 2 — Build your root screen

Create `lib/features/<your_module>/screens/<your_module>_screen.dart`.  
Your screen just needs to be a normal Flutter `StatefulWidget` or `StatelessWidget`.

**Example skeleton:**
```dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AlumniScreen extends StatelessWidget {
  const AlumniScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Text('Alumni Network', style: AppTheme.heading(24)),
      ),
    );
  }
}
```

### Step 3 — Register in app_navigation.dart

Open `lib/core/navigation/app_navigation.dart` and:

1. **Uncomment your import** at the top:
```dart
import '../../features/alumni/screens/alumni_screen.dart';
```

2. **Replace your placeholder** in the `appModules` list:
```dart
NavModule(
  label: 'Alumni',
  icon: Icons.people_outline_rounded,
  activeIcon: Icons.people_rounded,
  screen: const AlumniScreen(),   // ← your screen
  groupName: 'Group 2 — Alumni',
  isDone: true,                   // ← set to true when ready
),
```

That's all. The nav bar, routing, and shell handle everything else.

---

## 🎨 Shared Components You Can Use

Import from `core/widgets/shared_widgets.dart`:

| Widget | Use for |
|--------|---------|
| `AppBadge(label, color)` | Status badges / tags |
| `FilterPill(label, selected, onTap)` | Filter rows |
| `TagChip(label)` | Skill / category chips |
| `AppCard(child)` | Standard card container |
| `StatsCard(value, label, icon, color)` | Stats grid |
| `SectionHeader(title)` | Section titles with optional action |
| `EmptyState(icon, title, subtitle)` | Empty/no results screens |
| `AppButton(label, onPressed)` | Primary & outline buttons |

Import colours and text styles from `core/theme/app_theme.dart`:

```dart
AppTheme.heading(24)          // Syne bold heading
AppTheme.body(14)             // SpaceGrotesk body
AppTheme.label(12)            // SpaceGrotesk muted label

AppTheme.accent               // Purple #6C63FF
AppTheme.accentAlt            // Green #00E5A0
AppTheme.danger               // Red #FF6B6B
AppTheme.warning              // Yellow #FFD166
AppTheme.background           // #0A0A0F
AppTheme.surface              // #13131A
AppTheme.textSecondary        // #8888AA
```

---

## 🔧 Getting Started

```bash
# Clone the repo
git clone https://github.com/your-org/nust_campus_app.git
cd nust_campus_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

**Flutter version:** 3.x (Dart >=3.0.0)

---

## 🤝 GitHub Workflow

```bash
# Create your feature branch
git checkout -b feature/group2-alumni

# Work on your module, commit often
git add .
git commit -m "feat(alumni): add alumni listing screen"

# Push and open a Pull Request into main
git push origin feature/group2-alumni
```

- Each member should commit individually — **do not push one person's work under another's account**.
- Open a **Pull Request** when your feature is ready for review.
- Tag Group 1 for a review before merging.

---

## 📦 Dependencies (already in pubspec.yaml)

| Package | Purpose |
|---------|---------|
| `google_fonts` | Syne + SpaceGrotesk typography |
| `flutter_animate` | Smooth animations |
| `intl` | Date formatting |
| `url_launcher` | Open links externally |
| `cached_network_image` | Network images with caching |
