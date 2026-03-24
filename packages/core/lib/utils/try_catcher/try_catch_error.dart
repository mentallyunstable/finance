part of 'bloc_try_catcher_mixin.dart';

/// Describes error entry returned by [BlocTryCatcherMixin].
final class TryCatchError {
  final TryCatchErrorSource source;
  final CommonErrorModel? remoteError;
  final Object? exception;
  final StackTrace? stackTrace;
  final String? message;

  const TryCatchError._internal({
    required this.source,
    this.remoteError,
    this.exception,
    this.stackTrace,
    this.message,
  });

  factory TryCatchError.local({
    final Object? exception,
    final StackTrace? stackTrace,
    final String? message,
  }) =>
      TryCatchError._internal(
        source: TryCatchErrorSource.local,
        exception: exception,
        stackTrace: stackTrace,
        message: message,
      );

  factory TryCatchError.remote({
    required final CommonErrorModel remoteError,
    final Object? exception,
    final StackTrace? stackTrace,
    final String? message,
  }) =>
      TryCatchError._internal(
        source: TryCatchErrorSource.local,
        remoteError: remoteError,
        exception: exception,
        stackTrace: stackTrace,
        message: message,
      );

  String get errorMessage {
    if (source == TryCatchErrorSource.remote) {
      return remoteError?.errorMessage ?? ErrorMessages.unexpectedError;
    }

    return message ?? ErrorMessages.unexpectedError;
  }
}
