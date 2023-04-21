import 'package:flutter_dotenv/flutter_dotenv.dart';

final String SENTRY_DSN = dotenv.env['SENTRY_DSN']!;

final String DEVOPS_URL = dotenv.env['DEVOPS_URL']!;

const String LOCALE_KEY = '@@locale';

const String APP_NAME = 'Localization Editor';
