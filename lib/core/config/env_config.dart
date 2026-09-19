class EnvConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://ddlbhztqknozeaslbupj.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRkbGJoenRxa25vemVhc2xidXBqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk0Njk5MzMsImV4cCI6MjEwNTA0NTkzM30._wxSkOaLebjkC5nXXTR0OKPaLXjSgJndOxV09FL49vk',
  );

  /// Whether Supabase credentials have been injected at compile time
  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Default admin email
  static const String adminEmail = 'admin@freightops.com';

  /// Operational office contacts for communication fallbacks
  static const String officePhone = String.fromEnvironment(
    'OFFICE_PHONE',
    defaultValue: '917769964872',
  );

  static const String officeEmail = String.fromEnvironment(
    'OFFICE_EMAIL',
    defaultValue: 'adityashirsat1170@gmail.com',
  );

  /// REST API Base URL
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.freightops.com/v1',
  );
}
