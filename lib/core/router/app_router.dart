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
import '../../features/auth/presentation/pages/profile_setup_page.dart';
import '../../features/auth/presentation/pages/verification_pending_screen.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/directory/presentation/pages/directory_page.dart';
import '../../features/directory/presentation/pages/alumni_profile_page.dart';
import '../../features/mentorship/presentation/pages/mentorship_screen.dart';
import '../../features/mentorship/presentation/pages/mentorship_detail_screen.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chat/presentation/pages/chat_detail_page.dart';
import '../../features/events/presentation/pages/events_page.dart';
import '../../features/events/presentation/pages/event_details_page.dart';
import '../../features/jobs/presentation/pages/opportunities_page.dart';
import '../../features/jobs/presentation/pages/job_detail_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../features/notifications/presentation/pages/notifications_screen.dart';
import '../../features/admin/presentation/pages/admin_dashboard_screen.dart';
import '../widgets/custom_bottom_nav.dart';

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
      if (authStateAsync.isLoading) return null;

      final user = authStateAsync.value;
      final matchedLocation = state.matchedLocation;

      // 1. Always allow Splash, Onboarding, Login, Register, and ProfileSetup to display cleanly in sequence
      final isAuthFlowPage = matchedLocation == AppRoutes.splash ||
          matchedLocation == AppRoutes.onboarding ||
          matchedLocation == AppRoutes.login ||
          matchedLocation == AppRoutes.register ||
          matchedLocation == AppRoutes.profileSetup;

      if (isAuthFlowPage) {
        return null;
      }

      if (user == null) {
        return AppRoutes.login;
      }

      if (user.role == UserRole.alumni &&
          user.verificationStatus == VerificationStatus.pending) {
        return matchedLocation == '/pending' ? null : '/pending';
      }

      if (matchedLocation.startsWith(AppRoutes.admin)) {
        if (user.role != UserRole.admin) {
          return AppRoutes.home;
        }
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
        path: AppRoutes.profileSetup,
        builder: (context, state) => const ProfileSetupPage(),
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
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.directory,
            builder: (context, state) => const DirectoryPage(),
            routes: [
              GoRoute(
                path: ':alumniId',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => AlumniProfilePage(
                  alumniId: state.pathParameters['alumniId'],
                ),
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
            builder: (context, state) => const ChatPage(),
            routes: [
              GoRoute(
                path: ':conversationId',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => ChatDetailPage(
                      conversationId: state.pathParameters['conversationId'],
                    ),
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
            builder: (context, state) => const EventsPage(),
            routes: [
              GoRoute(
                path: ':eventId',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => EventDetailsPage(eventId: state.pathParameters['eventId']),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.jobs,
            builder: (context, state) => const OpportunitiesPage(),
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
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.directory)) return 1;
    if (location.startsWith(AppRoutes.events)) return 2;
    if (location.startsWith(AppRoutes.chat)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return -1;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.directory);
        break;
      case 2:
        context.go(AppRoutes.events);
        break;
      case 3:
        context.go(AppRoutes.chat);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}
