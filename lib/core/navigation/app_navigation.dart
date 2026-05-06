// ============================================================
//  core/navigation/app_navigation.dart
//
//  HOW TO ADD YOUR MODULE:
//  ─────────────────────────────────────────────────────────
//  1. Create your screen in lib/features/<your_module>/screens/
//  2. Import it below in the "── Group Imports ──" section
//  3. Add a NavModule entry to the `modules` list
//  4. That's it — the shell handles the rest automatically.
//
//  NavModule fields:
//    label      → text shown under nav icon
//    icon       → unselected icon
//    activeIcon → selected icon (can be same)
//    screen     → your root screen Widget
//    groupName  → your group name (shown in placeholder)
//    isDone     → set true when your module is ready
// ============================================================

import 'package:flutter/material.dart';

// ── Core ──────────────────────────────────────────────────────
import '../theme/app_theme.dart';

// ── Group Imports ─────────────────────────────────────────────
// GROUP 1 — Career Development (Jobs & Internships) ✅
import '../../features/jobs/screens/jobs_listing_screen.dart';

// GROUP 2 — Alumni Network
import '../../features/alumni/screens/alumni_listing_screen.dart';

// GROUP 3 — TED Talks
import '../../features/talks/screens/talks_listing_screen.dart';

// GROUP 4 — Events
import '../../features/events/screens/events_listing_screen.dart';

// GROUP 5 — Resources
import '../../features/resources/screens/resources_listing_screen.dart';

// GROUP 6 — [Your module name here]
// import '../../features/your_module/screens/your_screen.dart';

// ─────────────────────────────────────────────────────────────

class NavModule {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget screen;
  final String groupName;
  final bool isDone;

  const NavModule({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.screen,
    required this.groupName,
    this.isDone = false,
  });
}

// ── Module Registry ───────────────────────────────────────────
// Add your NavModule here when ready.
final List<NavModule> appModules = [
  // ✅ GROUP 1 — Career Development
  const NavModule(
    label: 'Jobs',
    icon: Icons.work_outline_rounded,
    activeIcon: Icons.work_rounded,
    screen: JobsListingScreen(),
    groupName: 'Group 1 — Career Dev',
    isDone: true,
  ),

  // ✅ GROUP 2 — Alumni Network
  const NavModule(
    label: 'Alumni',
    icon: Icons.people_outline_rounded,
    activeIcon: Icons.people_rounded,
    screen: AlumniListingScreen(),
    groupName: 'Group 2 — Alumni',
    isDone: true,
  ),

  // 🔲 GROUP 3 — TED Talks
  const NavModule(
    label: 'Talks',
    icon: Icons.mic_none_rounded,
    activeIcon: Icons.mic_rounded,
    screen: TalksListingScreen(),
    groupName: 'Group 3 — Talks',
    isDone: true,
  ),

  // ✅ GROUP 4 — Events
  const NavModule(
    label: 'Events',
    icon: Icons.event_outlined,
    activeIcon: Icons.event_rounded,
    screen: EventsListingScreen(),
    groupName: 'Group 4 — Events',
    isDone: true,
  ),

  // ✅ GROUP 5 — Resources
  const NavModule(
    label: 'Resources',
    icon: Icons.folder_outlined,
    activeIcon: Icons.folder_rounded,
    screen: ResourcesListingScreen(),
    groupName: 'Group 5 — Resources',
    isDone: true,
  ),
];

// ── App Shell ─────────────────────────────────────────────────
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: appModules.map((m) => m.screen).toList(),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.cardBorder, width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: appModules.asMap().entries.map((entry) {
              final i = entry.key;
              final mod = entry.value;
              final selected = _currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            selected ? mod.activeIcon : mod.icon,
                            color: selected ? AppTheme.accent : AppTheme.textSecondary,
                            size: 22,
                          ),
                          if (!mod.isDone)
                            Positioned(
                              top: -2,
                              right: -4,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppTheme.warning,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mod.label,
                        style: AppTheme.label(
                          10,
                          color: selected ? AppTheme.accent : AppTheme.textSecondary,
                          weight: selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ── Placeholder Screen ────────────────────────────────────────
// Each unfinished module shows this until the group is ready.
// Groups should REPLACE their placeholder entry in appModules[].
class _PlaceholderScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String groupName;

  const _PlaceholderScreen({
    required this.icon,
    required this.title,
    required this.description,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceHigh,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: Icon(icon, size: 48, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 24),
                Text(title, style: AppTheme.heading(24), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: AppTheme.label(15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceHigh,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.warning.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.construction_rounded, color: AppTheme.warning, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '$groupName — In Progress',
                        style: AppTheme.label(13, color: AppTheme.warning, weight: FontWeight.w600),
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
}
