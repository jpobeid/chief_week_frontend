import 'dart:convert';

import 'package:chief_week_frontend/data/http_data.dart' as datas;
import 'package:chief_week_frontend/functions/http_funcs.dart' as funcs;
import 'package:chief_week_frontend/providers.dart';
import 'package:chief_week_frontend/widgets/settings_layout.dart';
import 'package:file_picker/file_picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as https;

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool canWriteEmail = ref
        .watch(clearanceProvider)
        .state
        .sublist(0, 2)
        .every((element) => element);
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
            child: ref.watch(writingProvider).state
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      makeHomeButton(
                          id: 0,
                          context: context,
                          ref: ref,
                          buttonFunction: saveSettings,
                          label: 'Save settings'),
                      makeHomeButton(
                          id: 1,
                          context: context,
                          ref: ref,
                          buttonFunction: uploadSchedule,
                          label: 'Upload "schedule.csv"'),
                      canWriteEmail
                          ? makeHomeButton(
                              id: 2,
                              context: context,
                              ref: ref,
                              buttonFunction: writeEmail,
                              label: 'Write email')
                          : Container(),
                    ],
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  TextButton makeHomeButton({
    required Function buttonFunction,
    required String label,
    required BuildContext context,
    required WidgetRef ref,
    required int id,
  }) {
    return TextButton(
      child: Container(
        width: 200,
        height: 30,
        decoration: BoxDecoration(
          color: ref.watch(clearanceProvider).state[id]
              ? Colors.green
              : Colors.amber,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onPressed: () async {
        if (ref.read(clearanceProvider).state[id] == false) {
          int responseCode = await buttonFunction(context, ref);
          if (responseCode == 200) {
            List<bool> temp =
                List<bool>.from(ref.read(clearanceProvider).state);
            temp[id] = true;
            ref.read(clearanceProvider).state = temp;
          }
        }
      },
    );
  }

  Future<int> saveSettings(BuildContext context, WidgetRef ref) async {
    int responseCode = await funcs.setSettings(
        Map<String, String>.from(ref.read(settingsProvider).state));
    makeResponseSnackBar(context, responseCode, 'Successfully saved settings!');
    return responseCode;
  }

  Future<int> uploadSchedule(BuildContext context, WidgetRef ref) async {
    picker.FilePickerResult? results = await picker.FilePicker.platform
        .pickFiles(type: picker.FileType.custom, allowedExtensions: ['csv']);
    if (results != null) {
      https.Response response = await https.post(
          datas.urlBase.replace(path: datas.extSchedule),
          body: json.encode({datas.keySchedule: results.files.first.bytes}),
          headers: datas.headers);
      makeResponseSnackBar(context, response.statusCode,
          'Successfully uploaded "schedule.csv"!');
      return response.statusCode;
    } else {
      return 500;
    }
  }

  Future<int> writeEmail(BuildContext context, WidgetRef ref) async {
    ref.read(writingProvider).state = true;
    https.Response response = await https.get(
        datas.urlBase.replace(path: datas.extWrite),
        headers: datas.headers);
    funcs.downloadFileFromBytes(response.bodyBytes);
    ref.read(writingProvider).state = false;
    return response.statusCode;
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
