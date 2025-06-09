// You can place these at the top of your sign_up_screen.dart or in a separate validators.dart file

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) return 'Enter name';
  return null;
}

String? validateUsername(String? value) {
  if (value == null || value.trim().isEmpty) return 'Enter username';
  if (value.length < 3) return 'Username must be at least 3 characters';
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Enter email';
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Enter password';
  if (value.length < 6) return 'Password must be at least 6 characters';
  return null;
}

String? validateContact(String? value) {
  if (value == null || value.trim().isEmpty) return 'Enter contact no';
  if (value.length < 10) return 'Enter a valid contact number';
  return null;
}

String? validateGender(String? value) {
  if (value == null || value == 'Select Gender') return 'Select gender';
  return null;
}

String? validateDob(String? value) {
  if (value == null || value.isEmpty) return 'Select date of birth';
  return null;
}