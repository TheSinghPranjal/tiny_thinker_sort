import 'dart:convert';

import 'package:flutter/services.dart';

/// Reads game JSON documents from the Flutter asset bundle.
class AssetGameJsonDataSource {
  const AssetGameJsonDataSource({AssetBundle? bundle}) : _bundle = bundle;

  final AssetBundle? _bundle;

  AssetBundle get _assets => _bundle ?? rootBundle;

  Future<Map<String, dynamic>> loadMap(String assetPath) async {
    final raw = await _assets.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw FormatException('Expected a JSON object in $assetPath');
    }
    return Map<String, dynamic>.from(decoded);
  }
}
