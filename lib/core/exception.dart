import 'package:supabase_flutter/supabase_flutter.dart';

class KException {
  final String message;
  final String? code;

  KException(this.message, {this.code});

  @override
  String toString() => 'KException{message: $message, code: $code}';
}

/// Exception for Supabase Edge Function errors
class EdgeFunctionException implements Exception {
  final String message;
  final String? errorType;
  final int? statusCode;

  EdgeFunctionException({
    required this.message,
    this.errorType,
    this.statusCode,
  });

  /// Create EdgeFunctionException from FunctionException
  /// Parses error details and extracts error message and type
  factory EdgeFunctionException.fromFunctionException(
    FunctionException e, [
    String defaultMessage = 'Operation failed',
  ]) {
    if (e.details != null && e.details is Map<String, dynamic>) {
      final errorData = e.details as Map<String, dynamic>;
      final errorMessage = errorData['error'] as String? ?? defaultMessage;
      final errorType = errorData['error_type'] as String?;

      return EdgeFunctionException(
        message: errorMessage,
        errorType: errorType,
        statusCode: e.status,
      );
    }

    return EdgeFunctionException(
      message: e.reasonPhrase ?? defaultMessage,
      statusCode: e.status,
    );
  }

  @override
  String toString() => 'EdgeFunctionException: $message${errorType != null ? ' (type: $errorType)' : ''}';
}

