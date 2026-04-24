class JFormatException implements Exception {
  final String message;

  // Constructor that takes a message.
  const JFormatException([this.message = 'An unexpected format error occurred. please check your inpuut']);

factory JFormatException.fromMessage(String message){
  return JFormatException(message);
}

  // Create a format exception from a specific error code.
  factory JFormatException.fromCode(String code) {
    switch (code) {
      case 'invalid-email-format':
        return const JFormatException('The email address format is invalid. Please enter a valid email.');

      case 'invalid-phone-number-format':
        return const JFormatException('The provided phone number format is invalid. Please enter a valid number.');

      case 'invalid-date-format':
        return const JFormatException('The date format is invalid. Please enter a valid date.');

      case 'invalid-url-format':
        return const JFormatException('The URL format is invalid. Please enter a valid URL.');

      case 'invalid-credit-card-format':
        return const JFormatException('The credit card format is invalid. Please enter a valid credit card number.');

      case 'invalid-numeric-format':
        return const JFormatException('The numeric format is invalid. Please enter a valid number.');

      default:
        return const JFormatException('An unknown format error occurred. Please check your input and try again.');
    }
  }
}
