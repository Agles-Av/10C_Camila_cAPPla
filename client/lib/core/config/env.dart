import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiUrl => dotenv.env['API_URL']!;
  static bool get allowBadCert => dotenv.env['ALLOW_BAD_CERT'] == 'true';

  static bool get isDev => dotenv.env['APP_ENV'] == 'dev';
}
