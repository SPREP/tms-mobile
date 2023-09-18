class AppConfig {
  static const String liveBaseURL = "http://app.met.gov.to/api/v1";
  static const String localBaseURL = "http://met-api.lndo.site/api/v1";

  static const String baseUrl = localBaseURL;
  static const String loginEndpoint = "$baseUrl/login";
  static const String registerEndpoint = "$baseUrl/register";
  static const String forgotPasswordEndpoint = "$baseUrl/forgot-password";

  //internal credential for the app to post data to the API
  static const String userName = 'mobile_app';
  static const String password = 'intel13!';
}
