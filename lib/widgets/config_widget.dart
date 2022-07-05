import 'package:flutter/material.dart';

import '../constants/api_constants.dart';

class ConfigWidget extends StatefulWidget {
  const ConfigWidget({Key? key, this.onTap}) : super(key: key);

  final Function? onTap;

  @override
  State<ConfigWidget> createState() => _ConfigWidgetState();
}

class _ConfigWidgetState extends State<ConfigWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: GestureDetector(onTap: () {
        widget.onTap != null ? widget.onTap!() : null;
      }, onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              TextEditingController _baseUrlController =
                  TextEditingController();
              TextEditingController _socketUrlController =
                  TextEditingController();
              _baseUrlController.text = baseUrl;
              _socketUrlController.text = kSocketUrl;
              return Dialog(
                insetPadding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _baseUrlController,
                    ),
                    TextField(
                      controller: _socketUrlController,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          baseUrl = _baseUrlController.text.toString();
                          kSocketUrl = _socketUrlController.text.toString();
                        },
                        child: const Text('Save'),
                      ),
                    )
                  ],
                ),
              );
            });
      }),
    );
  }
}
