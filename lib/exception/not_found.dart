class NotFoundException implements Exception {
  final String message;
  final String? troubleshoot;

  NotFoundException({required this.message, this.troubleshoot});
}
