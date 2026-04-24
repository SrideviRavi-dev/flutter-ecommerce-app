class JValidator {

  static String? validateEmptyText(String firstName, String? value){
    if(value == null || value.isEmpty){
      return '$firstName is required';
    }
    return null;
  }

  static String? validateEmail(String? value){
    if (value == null || value.isEmpty){
      return 'Email is Required';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)){
      return 'Invalid email address';
    }
    return null;
  }

  static String? validatePassword(String? value){
    if(value == null || value.isEmpty){
      return 'Password is Required';
    }

    if (value.length < 6){
      return ' Password must be at least 6 Characters long.';
    }

    if(!value.contains(RegExp(r'[A-Z]'))){
      return 'Password must contain at least one Uppercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))){
      return 'Password must contain at least one number';
    }

    if(!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
      return 'Password must contain at least one special charecter.';
    }
    return null;
  }
 
  static String? validatePhoneNumber(String? value){
    if( value == null || value.isEmpty){
      return 'Phone Number is required';
    }

    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)){
      return 'Invalid phone number format (10 digits required)';
    }
    return null;
  }
}