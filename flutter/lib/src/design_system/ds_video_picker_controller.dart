import 'dart:io';

enum DSVideoPickerContent { local, empty }

class DSVideoPickerController {
  File? _video;

  File? get video => _video;

  DSVideoPickerContent get contentType {
    if (_video == null) {
      return DSVideoPickerContent.empty;
    }

    return DSVideoPickerContent.local;
  }

  set video(File? value) {
    _video = value;
  }
}
