/// Production log levels for field diagnostics on constrained Android devices
/// (Infinix/Tecno and similar): levels let you filter noise vs actionable crashes.
enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical;

  String get label => name.toUpperCase();
}
