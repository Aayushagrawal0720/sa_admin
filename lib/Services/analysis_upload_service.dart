import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class AnalysisUploadService with ChangeNotifier {
  String _analysisImagePath;
  bool _uploading = false;
  String _downloadUrl;

  setImage(String img) {
    _analysisImagePath = img;
    _uploading = true;
    notifyListeners();
    _uploadTask();
  }

  _uploadTask() {
    try {
      if (_analysisImagePath != null) {
        File _image = File(_analysisImagePath);
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference _analysisRef = storage.ref();
        UploadTask _task = _analysisRef
            .child("analysis/${DateTime.now().toString()}")
            .putFile(_image);
        _task.then((value) async {
          _uploading = false;
          String url = await value.ref.getDownloadURL();
          _downloadUrl = url;
          notifyListeners();
        });
      }
    } catch (err) {
      print(err);
    }
  }

  String getImage() => _analysisImagePath;

  bool isUploading() => _uploading;

  String getDownloadUrl() => _downloadUrl;
}
