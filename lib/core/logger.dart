import 'dart:developer' as dev;

/// Thin logging facade — never use bare `print`.
///
/// Levels follow `dart:developer` conventions (FINE..SHOUT).
class Log {
  const Log._();

  /// Debug-level message.
  static void d(String message) => dev.log(message, level: 500, name: 'vogue');

  /// Informational message.
  static void i(String message) => dev.log(message, level: 800, name: 'vogue');

  /// Warning — recoverable, but worth noticing.
  static void w(String message) => dev.log(message, level: 900, name: 'vogue');

  /// Error — something failed.
  static void e(String message, [Object? error, StackTrace? stackTrace]) =>
      dev.log(
        message,
        level: 1000,
        name: 'vogue',
        error: error,
        stackTrace: stackTrace,
      );
}
