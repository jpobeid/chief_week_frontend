import 'dart:convert';

import 'package:chief_week_frontend/data/global_data.dart' as globals;
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as https;
import 'package:chief_week_frontend/data/http_data.dart' as datas;

Future<Map<String, String>> getSettings() async {
  try {
    https.Response response = await https.get(
        datas.urlBase.replace(path: datas.extSettings),
        headers: datas.headers);
    return Map<String, String>.from(json.decode(response.body));
  } catch (e) {
    return {};
  }
}

Future<int> setSettings(Map<String, String> settings) async {
  https.Response response = await https.post(
      datas.urlBase.replace(path: datas.extSettings),
      headers: datas.headers,
      body: json.encode(settings));
  return response.statusCode;
}

void downloadFileFromBytes(List<int> bytes) {
  String url = html.Url.createObjectUrlFromBlob(html.Blob([bytes]));
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = globals.filenameDocx;
  html.document.body!.children.add(anchor);
  // download
  anchor.click();
  // cleanup
  html.document.body!.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
