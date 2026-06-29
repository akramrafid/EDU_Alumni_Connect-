class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  
  // Shell routes (tabs)
  static const String home = '/home'; // maps to directory
  static const String directory = '/directory';
  static const String mentorship = '/mentorship';
  static const String chat = '/chat';
  static const String profile = '/profile';

  // Sub-routes (sub-paths)
  static const String alumniDetail = 'directory/:alumniId';
  static const String mentorshipDetail = 'mentorship/:requestId';
  static const String chatDetail = 'chat/:conversationId';
  static const String eventDetail = 'events/:eventId';
  static const String jobDetail = 'jobs/:jobId';
  static const String profileEdit = 'profile/edit';

  // Independent top-level routes
  static const String events = '/events';
  static const String jobs = '/jobs';
  static const String notifications = '/notifications';
  static const String admin = '/admin';
}
