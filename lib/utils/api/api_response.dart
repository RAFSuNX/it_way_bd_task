class ApiResponse<T> {
  final T? data;
  final bool success;
  final String message;
  final int? statusCode;

  ApiResponse({
    this.data,
    required this.success,
    required this.message,
    this.statusCode,
  });

  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    int? statusCode,
  }) {
    return ApiResponse(
      data: data,
      success: true,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({
    String message = 'An error occurred',
    int? statusCode,
  }) {
    return ApiResponse(
      data: null,
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}