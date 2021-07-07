  String validateName(String value) {
    if(value == null || value.isEmpty) {
      return 'Name field is required';
    }
    else return null;
  }
  
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(value == null || value.isEmpty) {
      return 'Email field is required';
    }
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    if(value == null || value.isEmpty) {
      return 'Password field is required';
    }
    if(value.length < 6) {
      return 'Password field can\'t less than 6 character';
    }
    else return null;
  }

