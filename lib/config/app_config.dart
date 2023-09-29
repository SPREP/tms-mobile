class AppConfig {
  static const String liveBaseURL = "http://app.met.gov.to/api/v1";
  static const String localBaseURL = "http://met-api.lndo.site/api/v1";

  static const String baseUrl = localBaseURL;

  //user endpoints
  static const String loginEndpoint = "$baseUrl/user/login?_format=json";
  static const String registerEndpoint = "$baseUrl/user/register?_format=json";
  static const String logoutEndpoint = "$baseUrl/user/logout?_format=json";
  static const String forgotPasswordEndpoint =
      "$baseUrl/user/forgot?_format=json";

  //internal credential for the app to post data to the API
  static const String userName = 'mobile_app';
  static const String password = 'intel13!';
}
