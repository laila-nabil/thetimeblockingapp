
class Validator {

  static bool isEmailValid(String email) {
    // Regular expression for email validation
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z][a-zA-Z0-9._-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9]+)*$");

    // Check if the email matches the regular expression
    if (emailRegex.hasMatch(email)) {
      // Split the email into local and domain parts
      List<String> parts = email.split('@');
      String localPart = parts[0];
      String domainPart = parts[1];

      // Check the length of the domain part
      if (domainPart.length < 5 && domainPart.length < 253) return false;

      // Check the length of the local part
      if (localPart.length < 2) return false;

      // Check if the domain part contains only valid characters
      if (!RegExp(r"^[A-Za-z0-9.-]+$").hasMatch(domainPart)) return false;


      return true;
    } else {
      return false;
    }
  }

}
