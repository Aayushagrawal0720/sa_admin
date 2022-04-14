import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class SpecialStorage with ChangeNotifier {
  Map<String, dynamic> _specialData = Map<String, dynamic>();

  //PATH WHERE STOTAGE FILE WILL BE CREATED
  static const String _specialStorageUrl =
      "/storage/emulated/0/Android/data/com.createwealth.admin";

  //FILE NAME OF SPECIAL STORAGE CLASS
  //FILE WILL BE IN .txt FORMAT AND IT WILL CONTAIN DATA IN JSON TEXT FORMAT
  static const String _fileName = "special.txt";

  //INITIALIZE DATA TO MEMORY
  //THIS SHOULD CALL DURING THE INITIALIZATION OF APPLICATION
  init() async {
    //FILE OF SPECIaAL STORAGE
    final File file = File('$_specialStorageUrl/$_fileName');
    String fileData = await file.readAsString();
    _specialData = json.decode(fileData) as Map;
  }

  writeFile() async {
    final File file = File('$_specialStorageUrl/$_fileName');
    await file.writeAsString(_specialData.toString());
  }

  setData(String key, dynamic value) async {
    if (_specialData.isNotEmpty) {
      _specialData[key] = value;
      writeFile();
    } else {
      await init();
      _specialData[key] = value;
      writeFile();
    }
  }

  Future<dynamic> getData(String key) async {
    if (_specialData.isNotEmpty) {
      return _specialData[key];
    } else {
      await init();
      return _specialData[key];
    }
  }
}
