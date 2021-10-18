import 'package:chief_week_frontend/data/global_data.dart' as globals;
import 'package:universal_html/html.dart' as html;

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