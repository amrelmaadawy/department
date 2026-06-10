import 'package:flutter/material.dart';

import 'app_colors_extension.dart';

extension ThemeExtensionBuildContext on BuildContext {
  AppColorsExtension get colors => Theme.of(this).extension<AppColorsExtension>()!;
}
