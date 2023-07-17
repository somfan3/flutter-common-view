import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformIndicator extends StatelessWidget {
  const PlatformIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isIOS ? _buildIosIndicator() : _buildAndroidIndicator(),
    );
  }

  _buildAndroidIndicator() {
    return const CircularProgressIndicator();
  }

  _buildIosIndicator() {
    return const CupertinoActivityIndicator(radius: 12);
  }
}
