import 'dart:async';

import 'package:core/constant/error_messages.dart';
import 'package:core/domain/common_error_model.dart';
import 'package:core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'try_catch_error.dart'; // Utility mixin for [Bloc] classes to handle exceptions and emit error states.
part 'try_catch_error_source.dart';

mixin BlocTryCatcherMixin<E, S> on Bloc<E, S> {
  FutureOr<void> tryCatch(
    final E event,
    final Emitter<S> emit,
    final AsyncCallback callback,
  ) async {
    try {
      await callback();
    } on DioException catch (exception, stackTrace) {
      return _catchDioException(
        event: event,
        emit: emit,
        exception: exception,
        stackTrace: stackTrace,
      );
    } catch (exception, stackTrace) {
      logger.error('$runtimeType Exception', exception: exception, stackTrace: stackTrace);

      return emitError(emit, TryCatchError.local(exception: exception, stackTrace: stackTrace));
    }
  }

  void _catchDioException({
    required final E event,
    required final Emitter<S> emit,
    required final DioException exception,
    required final StackTrace stackTrace,
  }) {
    try {
      logger.error('$runtimeType DioException by $event', exception: exception, stackTrace: stackTrace);

      final data = exception.response?.data;

      if (data == null) {
        return emitError(emit, TryCatchError.local(exception: exception, stackTrace: stackTrace));
      }

      final error = CommonErrorModel.fromJson(data);

      return emitError(
        emit,
        TryCatchError.remote(remoteError: error, exception: exception, stackTrace: stackTrace),
      );
    } catch (exception, stackTrace) {
      logger.error('$runtimeType Exception', exception: exception, stackTrace: stackTrace);

      return emitError(emit, TryCatchError.local(exception: exception, stackTrace: stackTrace));
    }
  }

  void emitError(final Emitter<S> emit, final TryCatchError error);
}
