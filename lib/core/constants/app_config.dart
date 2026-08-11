enum AppEnvironment { dev, staging, prod }

class AppConfig {
  static const bool useMock = false; // Live Firebase active

  final AppEnvironment environment;
  final String firebaseProjectId;
  final String algoliaAppId;
  final String algoliaSearchKey;

  const AppConfig({
    required this.environment,
    required this.firebaseProjectId,
    required this.algoliaAppId,
    required this.algoliaSearchKey,
  });

  factory AppConfig.fromEnvironment() {
    const envString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    switch (envString) {
      case 'prod':
        return const AppConfig(
          environment: AppEnvironment.prod,
          firebaseProjectId: 'edu-alumni-connect-a6511',
          algoliaAppId: 'PROD_ALGOLIA_APP_ID',
          algoliaSearchKey: 'PROD_ALGOLIA_SEARCH_KEY',
        );
      case 'staging':
        return const AppConfig(
          environment: AppEnvironment.staging,
          firebaseProjectId: 'edu-alumni-connect-a6511',
          algoliaAppId: 'STAGING_ALGOLIA_APP_ID',
          algoliaSearchKey: 'STAGING_ALGOLIA_SEARCH_KEY',
        );
      case 'dev':
      default:
        return const AppConfig(
          environment: AppEnvironment.dev,
          firebaseProjectId: 'edu-alumni-connect-a6511',
          algoliaAppId: 'DEV_ALGOLIA_APP_ID',
          algoliaSearchKey: 'DEV_ALGOLIA_SEARCH_KEY',
        );
    }
  }
}
