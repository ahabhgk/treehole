class Validator {
  static String? username(String? val) {
    if (val == null || val.length < 3) {
      return 'Please enter 3 letters at least';
    }
    return null;
  }

  static String? email(String? val) {
    if (val == null || val.isEmpty) {
      return 'Email can\'t be empty';
    } else if (RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(val)) {
      return null;
    }
    return 'Please enter valid email';
  }

  static String? password(String? val) {
    if (val == null || val.isEmpty) {
      return 'Password can\'t be empty';
    } else if (val.length >= 6) {
      return null;
    }
    return 'Please enter valid password';
  }

  static String? postContent(String? val) {
    if (val == null || val.isEmpty) {
      return 'Post content can\'t be empty';
    }
    return null;
  }
}
