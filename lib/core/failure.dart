import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// All failures surfaced to the app are leaves of this sealed union.
///
/// Adapters translate their native errors into one of these at the
/// boundary; cubits map them to user-facing copy.
@freezed
sealed class AppFailure with _$AppFailure {
  /// The device could not reach vfuae.com (offline, timeout, bad status).
  const factory AppFailure.network({String? detail}) = NetworkFailure;

  /// The page was fetched but no usable WOD entries could be parsed.
  const factory AppFailure.parse({String? detail}) = ParseFailure;

  /// The local cache could not be read or written.
  const factory AppFailure.cache({String? detail}) = CacheFailure;
}

/// Human-readable copy for a failure, used by the UI error states.
extension AppFailureMessage on AppFailure {
  String get message => switch (this) {
        NetworkFailure() =>
          "Couldn't reach Vogue Fitness. Check your connection and retry.",
        ParseFailure() =>
          'The schedule page changed shape and could not be read.',
        CacheFailure() => 'Stored schedule could not be loaded.',
      };
}
