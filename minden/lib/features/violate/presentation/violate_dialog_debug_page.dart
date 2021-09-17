import 'package:flutter/material.dart';

class ViolateDialogDebugPage extends StatefulWidget {
  const ViolateDialogDebugPage({Key? key}) : super(key: key);

  @override
  _ViolateDialogDebugPageState createState() => _ViolateDialogDebugPageState();
}

class _ViolateDialogDebugPageState extends State<ViolateDialogDebugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('通報する'),
            ),
          ],
        ),
      ),
    );
  }
}
