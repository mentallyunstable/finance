/// Contains const remote API urls for the application.
/// Base URL provided via ENV variables in [EnvironmentStore].
class ApiUrl {
  const ApiUrl._();

  // User
  static const usersMe = 'users/me/';
  static const usersCheckOtp = 'users/check-otp/';
}
