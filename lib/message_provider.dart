class MessageProvider {
  static String getMessage(int index) {
    switch (index) {
      case 0:
        return '목록';
      case 1:
        return '일기쓰기';
      case 2:
        return '정보';
      default:
        return '';
    }
  }
}
