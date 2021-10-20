import 'package:chief_week_frontend/data/global_data.dart' as globals;
import 'package:flutter/material.dart';

class SettingsLayout extends StatefulWidget {
  const SettingsLayout({Key? key, required this.flexMain}) : super(key: key);

  final int flexMain;

  static const TextStyle styleMain =
      TextStyle(fontSize: 16, color: Colors.black);
  static const TextStyle styleHeader =
      TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  bool _isEditingMain = false;
  bool _isEditingReminders = false;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    for (var element in globals.settingValuesDefaults) {
      _controllers.add(TextEditingController(text: element));
    }
    super.initState();
  }

  @override
  void dispose() {
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            child: ListView.builder(
                itemCount: globals.settingKeys.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            globals.settingKeys[index],
                            style: SettingsLayout.styleMain,
                            textAlign: TextAlign.center,
                          ),
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: _isEditingMain
                              ? TextField(
                                  controller: _controllers[index],
                                  style: SettingsLayout.styleMain,
                                )
                              : Text(
                                  globals.settingValuesDefaults[index],
                                  style: SettingsLayout.styleMain,
                                ),
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                }),
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
            flex: 5,
            child: Container(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
