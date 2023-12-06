class AppConfig {
  static const String prodURL = "http://app.met.gov.to";
  static const String localUrl = "http://127.0.0.1:49917";

  static const String liveBaseURL = "$prodURL/api/v1";
  static const String localBaseURL = "$localUrl/api/v1";

  static const String baseUrl = liveBaseURL;

  //user endpoints
  static const String loginEndpoint = "$baseUrl/user/login?_format=json";
  static const String registerEndpoint = "$baseUrl/user/register?_format=json";
  static const String logoutEndpoint = "$baseUrl/user/logout?_format=json";
  static const String forgotPasswordEndpoint =
      "$baseUrl/user/forgot?_format=json";

  //internal credential for the app to post data to the API
  static const String userName = 'mobile_app';
  static const String password = 'intel13!';

  //current version
  static const String version = '1.0.0';
}
