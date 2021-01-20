class SearchTextChecker {
  static final RegExp _regExEmoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
  static final RegExp _regExIncludedLetters = RegExp(r'^[a-zA-Z0-9 ]+$');
  static bool lengthAboveTwentyChecker(String _searchText) {
    if (_searchText.length > 20) {
      return true;
    }
    return false;
  }

  static bool emojiAndsymbolChecker(String _searchText) {
    if (_searchText.contains(_regExEmoji) ||
        !_searchText.contains(_regExIncludedLetters)) {
      return true;
    }
    return false;
  }
}
