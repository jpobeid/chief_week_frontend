import 'dart:convert';

import 'package:chief_week_frontend/data/http_data.dart' as datas;
import 'package:chief_week_frontend/functions/http_funcs.dart' as httpFuncs;
import 'package:file_picker/file_picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chief Weekly Email'),
      ),
      body: Column(
        children: [
          const Text('Setting 1'),
          const Text('Setting 2'),
          TextButton(
            child: const Text(
              'Upload settings (.txt)',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              picker.FilePickerResult? results =
                  await picker.FilePicker.platform.pickFiles(
                      type: picker.FileType.custom, allowedExtensions: ['txt']);
              if (results != null) {
                https.Response response = await https.post(
                    datas.urlBase.replace(path: datas.extSettings),
                    body: json
                        .encode({datas.keySettings: results.files.first.bytes}),
                    headers: datas.headers);
                print(response.statusCode);
              }
            },
          ),
          TextButton(
            child: const Text(
              'Upload schedule (.csv)',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              picker.FilePickerResult? results =
                  await picker.FilePicker.platform.pickFiles(
                      type: picker.FileType.custom, allowedExtensions: ['csv']);
              if (results != null) {
                https.Response response = await https.post(
                    datas.urlBase.replace(path: datas.extSchedule),
                    body: json
                        .encode({datas.keySchedule: results.files.first.bytes}),
                    headers: datas.headers);
                print(response.statusCode);
              }
            },
          ),
          _isWriting ? CircularProgressIndicator() : TextButton(
            child: const Text(
              'Get file!',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              setState(() {
                _isWriting = true;
              });
              https.Response response = await https.get(
                  datas.urlBase.replace(path: datas.extWrite),
                  headers: datas.headers);
              httpFuncs.downloadFileFromBytes(response.bodyBytes);
              print(response.statusCode);
              setState(() {
                _isWriting = false;
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.blue,
    );
  }
}
