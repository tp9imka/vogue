import 'failure.dart';

/// A success-or-failure result without throwing.
sealed class Result<T> {
  const Result();
}

/// A successful [Result] carrying [value].
class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

/// A failed [Result] carrying [failure].
class Err<T> extends Result<T> {
  const Err(this.failure);

  final AppFailure failure;
}
