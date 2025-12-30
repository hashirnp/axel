class ErrorMapper {
  static String map(Object error) {
    final msg = error.toString();

    if (msg.contains('SocketException')) {
      return 'No internet connection';
    }
    if (msg.contains('Timeout')) {
      return 'Request timed out';
    }
    if (msg.contains('Username already exists')) {
      return 'Username already exists';
    }
    if (msg.contains('Invalid credentials')) {
      return 'Invalid username or password';
    }

    return msg.replaceAll('Exception: ', '');
  }
}
