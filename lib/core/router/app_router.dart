import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../constants/app_routes.dart';

// Feature Page Imports
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/onboarding_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/auth/presentation/pages/verification_pending_screen.dart';
import '../../features/directory/presentation/pages/directory_screen.dart';
import '../../features/directory/presentation/pages/alumni_detail_screen.dart';
import '../../features/mentorship/presentation/pages/mentorship_screen.dart';
import '../../features/mentorship/presentation/pages/mentorship_detail_screen.dart';
import '../../features/chat/presentation/pages/conversations_screen.dart';
import '../../features/chat/presentation/pages/chat_screen.dart';
import '../../features/events/presentation/pages/events_screen.dart';
import '../../features/events/presentation/pages/event_detail_screen.dart';
import '../../features/jobs/presentation/pages/jobs_screen.dart';
import '../../features/jobs/presentation/pages/job_detail_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../features/notifications/presentation/pages/notifications_screen.dart';
import '../../features/admin/presentation/pages/admin_dashboard_screen.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

@riverpod
GoRouter router(RouterRef ref) {
  final authStateAsync = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      // If auth state is loading, wait before redirecting
      if (authStateAsync.isLoading) return null;

      final user = authStateAsync.value;
      final matchedLocation = state.matchedLocation;

      final isAuthPage = matchedLocation == AppRoutes.login ||
          matchedLocation == AppRoutes.register ||
          matchedLocation == AppRoutes.onboarding ||
          matchedLocation == AppRoutes.splash;

      // Unauthenticated users are redirected to login, unless they are already on an auth page
      if (user == null) {
        return isAuthPage ? null : AppRoutes.login;
      }

      // Alumni whose verification is pending are forced to the pending page
      if (user.role == UserRole.alumni &&
          user.verificationStatus == VerificationStatus.pending) {
        return matchedLocation == '/pending' ? null : '/pending';
      }

      // Role-based gate for Web Admin panel
      if (matchedLocation.startsWith(AppRoutes.admin)) {
        if (user.role != UserRole.admin) {
          return AppRoutes.home;
        }
      }

      // Logged in users on auth pages are redirected home
      if (isAuthPage) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) => const VerificationPendingScreen(),
      ),
      GoRoute(
        path: '/pending',
        builder: (context, state) => const VerificationPendingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        redirect: (context, state) => AppRoutes.directory,
      ),
      GoRoute(
        path: AppRoutes.admin,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Shell Route for Tabbed interface
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.directory,
            builder: (context, state) => const DirectoryScreen(),
            routes: [
              GoRoute(
                path: ':alumniId',
                builder: (context, state) => const AlumniDetailScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.mentorship,
            builder: (context, state) => const MentorshipScreen(),
            routes: [
              GoRoute(
                path: ':requestId',
                builder: (context, state) => const MentorshipDetailScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.chat,
            builder: (context, state) => const ConversationsScreen(),
            routes: [
              GoRoute(
                path: ':conversationId',
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfileScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.events,
            builder: (context, state) => const EventsScreen(),
            routes: [
              GoRoute(
                path: ':eventId',
                builder: (context, state) => const EventDetailScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.jobs,
            builder: (context, state) => const JobsScreen(),
            routes: [
              GoRoute(
                path: ':jobId',
                builder: (context, state) => const JobDetailScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.directory)) return 0;
    if (location.startsWith(AppRoutes.mentorship)) return 1;
    if (location.startsWith(AppRoutes.chat)) return 2;
    if (location.startsWith(AppRoutes.profile)) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.directory);
        break;
      case 1:
        context.go(AppRoutes.mentorship);
        break;
      case 2:
        context.go(AppRoutes.chat);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Directory', // TODO: l10n
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Mentorship', // TODO: l10n
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat', // TODO: l10n
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile', // TODO: l10n
          ),
        ],
      ),
    );
  }
}
