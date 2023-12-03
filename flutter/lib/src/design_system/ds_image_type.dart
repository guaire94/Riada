import 'package:flutter/cupertino.dart';
import 'package:riada/src/design_system/ds_border_radius.dart';

enum DSImageType { fullScreen, post, medium, small, avatar }

extension DSImageTypeExtension on DSImageType {
  double get height {
    switch (this) {
      case DSImageType.fullScreen:
        return double.infinity;
      case DSImageType.post:
        return double.infinity;
      case DSImageType.medium:
        return 100;
      case DSImageType.small:
        return 60;
      case DSImageType.avatar:
        return 50;
    }
  }

  double get width {
    switch (this) {
      case DSImageType.fullScreen:
        return double.infinity;
      case DSImageType.post:
        return 120;
      case DSImageType.medium:
        return 100;
      case DSImageType.small:
        return 60;
      case DSImageType.avatar:
        return 50;
    }
  }

  double get iconSize {
    switch (this) {
      case DSImageType.fullScreen:
        return 100;
      case DSImageType.post:
        return 100;
      case DSImageType.medium:
        return 40;
      case DSImageType.small:
        return 20;
      case DSImageType.avatar:
        return 16;
    }
  }

  bool get hasLoaderPlaceholder {
    switch (this) {
      case DSImageType.fullScreen:
        return true;
      default:
        return false;
    }
  }

  BorderRadius get borderRadius {
    switch (this) {
      case DSImageType.avatar:
        return BorderRadius.circular(DSBorderRadius.input);
      case DSImageType.fullScreen:
        return BorderRadius.circular(DSBorderRadius.none);
      case DSImageType.post:
        return BorderRadius.zero;
      default:
        return BorderRadius.circular(DSBorderRadius.input);
    }
  }
}
