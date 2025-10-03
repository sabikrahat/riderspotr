class KException {
  final String message;
  final String? code;

  KException(this.message, {this.code});

  @override
  String toString() => 'KException{message: $message, code: $code}';
}
