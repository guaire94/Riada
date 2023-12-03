import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riada/src/design_system/ds_color.dart';
import 'package:riada/src/design_system/ds_image_type.dart';

class DSImage extends StatefulWidget {
  final DSImageType _type;
  final String _url;
  final bool _isEnabled;

  DSImage({
    Key? key,
    required DSImageType type,
    required String url,
    bool isEnabled = true,
  })  : _type = type,
        _url = url,
        _isEnabled = isEnabled,
        super(key: key);

  @override
  State<DSImage> createState() => _DSImageState();
}

class _DSImageState extends State<DSImage> {
  @override
  Widget build(BuildContext context) {
    Widget child = _getImageWidget();

    if (widget._isEnabled == false) {
      child = Opacity(
        opacity: 1,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black,
            BlendMode.saturation,
          ),
          child: _getImageWidget(),
        ),
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      height: widget._type.height,
      width: widget._type.width,
      decoration: BoxDecoration(
        color: DSColor.neutral10,
        borderRadius: widget._type.borderRadius,
      ),
      child: child,
    );
  }

  Widget _getImageWidget() {
    Widget? loader;
    if (widget._type.hasLoaderPlaceholder) {
      loader = Center(
        child: CircularProgressIndicator(
          color: DSColor.neutral35,
        ),
      );
    }

    if (widget._url.startsWith("http")) {
      return CachedNetworkImage(
        imageUrl: widget._url,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: DSColor.neutral10,
          child: loader,
        ),
      );
    }
    return Image.file(File(widget._url), fit: BoxFit.cover);
  }
}
