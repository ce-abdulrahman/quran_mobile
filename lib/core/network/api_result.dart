// ─────────────────────────────────────────────────────────────────────────────
// API Result Sealed Class
// ─────────────────────────────────────────────────────────────────────────────

sealed class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, int? statusCode, T? cachedData) error,
  }) {
    if (this is ApiSuccess<T>) {
      return success((this as ApiSuccess<T>).data);
    } else if (this is ApiError<T>) {
      final err = this as ApiError<T>;
      return error(err.message, err.statusCode, err.cachedData);
    }
    throw AssertionError('Unknown ApiResult subtype: $this');
  }

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isError => this is ApiError<T>;

  T? get dataOrNull {
    if (this is ApiSuccess<T>) {
      return (this as ApiSuccess<T>).data;
    }
    if (this is ApiError<T>) {
      return (this as ApiError<T>).cachedData;
    }
    return null;
  }
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiError<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  final T? cachedData;

  const ApiError(
    this.message, {
    this.statusCode,
    this.cachedData,
  });
}
