import 'dart:convert';

import 'package:chief_week_frontend/data/http_data.dart' as datas;
import 'package:chief_week_frontend/functions/http_funcs.dart' as funcs;
import 'package:chief_week_frontend/widgets/settings_layout.dart';
import 'package:file_picker/file_picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as https;

final writingProvider = StateProvider((ref) => false);
final settingsProvider = StateProvider((ref) => {});

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chief weekly email'),
      ),
      body: Column(
        children: [
          const SettingsLayout(
            flexMain: 4,
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                makeHomeButton(
                    context: context,
                    ref: ref,
                    buttonFunction: saveSettings,
                    label: 'Save settings'),
                makeHomeButton(
                    context: context,
                    ref: ref,
                    buttonFunction: uploadSchedule,
                    label: 'Upload "schedule.csv"'),
                ref.watch(writingProvider).state
                    ? const CircularProgressIndicator()
                    : makeHomeButton(
                        context: context,
                        ref: ref,
                        buttonFunction: writeEmail,
                        label: 'Write email'),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  TextButton makeHomeButton(
      {required Function buttonFunction,
      required String label,
      required BuildContext context,
      required WidgetRef ref}) {
    return TextButton(
      child: Container(
        width: 200,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onPressed: () => buttonFunction(context, ref),
    );
  }

  Future<void> saveSettings(BuildContext context, WidgetRef ref) async {
    int responseCode = await funcs.setSettings(
        Map<String, String>.from(ref.read(settingsProvider).state));
    makeResponseSnackBar(context, responseCode, 'Successfully saved settings!');
  }

  Future<void> uploadSchedule(BuildContext context, WidgetRef ref) async {
    picker.FilePickerResult? results = await picker.FilePicker.platform
        .pickFiles(type: picker.FileType.custom, allowedExtensions: ['csv']);
    if (results != null) {
      https.Response response = await https.post(
          datas.urlBase.replace(path: datas.extSchedule),
          body: json.encode({datas.keySchedule: results.files.first.bytes}),
          headers: datas.headers);
      makeResponseSnackBar(context, response.statusCode,
          'Successfully uploaded "schedule.csv"!');
    }
  }

  Future<void> writeEmail(BuildContext context, WidgetRef ref) async {
    ref.read(writingProvider).state = true;
    https.Response response = await https.get(
        datas.urlBase.replace(path: datas.extWrite),
        headers: datas.headers);
    funcs.downloadFileFromBytes(response.bodyBytes);
    ref.read(writingProvider).state = false;
  }

  void makeResponseSnackBar(
      BuildContext context, int responseCode, String messageSuccess) {
    if (responseCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(messageSuccess)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Network error...')));
    }
  }
}
