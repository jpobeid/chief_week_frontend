import 'package:chief_week_frontend/functions/http_funcs.dart';
import 'package:chief_week_frontend/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsLayout extends ConsumerStatefulWidget {
  const SettingsLayout({Key? key, required this.flexMain}) : super(key: key);

  final int flexMain;

  static const TextStyle styleMain =
      TextStyle(fontSize: 16, color: Colors.black);
  static const TextStyle styleHeader =
      TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold);

  @override
  ConsumerState<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends ConsumerState<SettingsLayout> {
  bool _isEditingMain = false;
  bool _isEditingReminders = false;
  final Map<String, String> _settingsMain = {};
  final Map<String, String> _settingsReminders = {};
  final List<TextEditingController> _controllersMain = [];
  final List<TextEditingController> _controllersReminders = [];

  @override
  void initState() {
    initSettings();
    super.initState();
  }

  Future<void> initSettings() async {
    Map<String, String> settings = await getSettings();
    ref.read(settingsProvider).state = settings;
    settings.forEach((key, value) {
      if (key.contains('reminder')) {
        _settingsReminders.addAll({key: value});
      } else {
        _settingsMain.addAll({key: value});
      }
    });
    for (var element in _settingsMain.values) {
      _controllersMain.add(TextEditingController(text: element));
    }
    for (var element in _settingsReminders.values) {
      _controllersReminders.add(TextEditingController(text: element));
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controllersMain.clear();
    _controllersReminders.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool canBuild = _settingsMain.isNotEmpty && _settingsReminders.isNotEmpty;
    return canBuild
        ? Expanded(
            flex: widget.flexMain,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      const Text(
                        'Primary settings',
                        style: SettingsLayout.styleHeader,
                      ),
                      IconButton(
                        onPressed: () {
                          if (_isEditingMain) {
                            saveEdits(
                                map: _settingsMain,
                                controllers: _controllersMain);
                          }
                          setState(() {
                            _isEditingMain = !_isEditingMain;
                          });
                        },
                        icon: _isEditingMain
                            ? const Icon(Icons.check_circle_outline)
                            : const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: makeListView(
                        map: _settingsMain,
                        isEditing: _isEditingMain,
                        controllers: _controllersMain),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      const Text(
                        'Reminders',
                        style: SettingsLayout.styleHeader,
                      ),
                      IconButton(
                        onPressed: () {
                          if (_isEditingReminders) {
                            saveEdits(
                                map: _settingsReminders,
                                controllers: _controllersReminders);
                          }
                          setState(() {
                            _isEditingReminders = !_isEditingReminders;
                          });
                        },
                        icon: _isEditingReminders
                            ? const Icon(Icons.check_circle_outline)
                            : const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: makeListView(
                        map: _settingsReminders,
                        isEditing: _isEditingReminders,
                        controllers: _controllersReminders),
                  ),
                ),
              ],
            ),
          )
        : const Expanded(child: Center(child: CircularProgressIndicator()));
  }

  ListView makeListView(
      {required Map<String, String> map,
      required bool isEditing,
      required List<TextEditingController> controllers}) {
    return ListView.builder(
        controller: ScrollController(),
        itemCount: map.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    map.keys.toList()[index],
                    style: SettingsLayout.styleMain,
                    textAlign: TextAlign.center,
                  ),
                  color: const Color.fromARGB(100, 0, 200, 100),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  child: isEditing
                      ? TextField(
                          controller: controllers[index],
                          style: SettingsLayout.styleMain,
                        )
                      : Text(
                          map.values.toList()[index],
                          style: SettingsLayout.styleMain,
                        ),
                  color: const Color.fromARGB(100, 200, 0, 100),
                ),
              ),
            ],
          );
        });
  }

  void saveEdits(
      {required Map<String, String> map,
      required List<TextEditingController> controllers}) {
    List<String> keys = map.keys.toList();
    int i = 0;
    for (var element in controllers) {
      ref.read(settingsProvider).state[keys[i]] = element.text;
      map[keys[i]] = element.text;
      i++;
    }
  }
}
