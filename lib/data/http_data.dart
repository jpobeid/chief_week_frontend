Uri urlBase = Uri(scheme: 'http', host: '45.79.101.14', port: 80);
String extSettings = '/settings';
String extSchedule = '/schedule';
String extWrite = '/weekly_email';

String keySettings = 'settingsBytes';
String keySchedule = 'scheduleBytes';

const Map<String, String> headers = {
  "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
  "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "Access-Control-Allow-Methods": "POST, OPTIONS"
};