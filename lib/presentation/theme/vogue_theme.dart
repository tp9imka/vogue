/// `ThemeData` builders.
///
/// Dark is the primary theme — the app currently locks to `ThemeMode.dark`
/// in `app.dart`. A light theme is provided for completeness; widgets that
/// still hard-code `VogueColors.surface` / `ink` will read as dark even
/// under the light theme until they migrate to `Theme.of(context)`.
///
/// These builders wire the token classes (`VogueColors`, `VogueSpace`,
/// `VogueRadius`, `VogueElevation`) and the `VogueTypography` scale into a
/// single `ThemeData`, so feature code only ever touches `Theme.of(context)`.
library;

import 'package:flutter/material.dart';
import 'package:vogue_wod/presentation/theme/vogue_tokens.dart';
import 'package:vogue_wod/presentation/theme/vogue_typography.dart';

/// Builds the primary dark theme.
ThemeData buildVogueDarkTheme() {
  const colorScheme = ColorScheme.dark(
    primary: VogueColors.primary,
    onPrimary: VogueColors.onPrimary,
    primaryContainer: VogueColors.primarySoft,
    onPrimaryContainer: VogueColors.primary,
    secondary: VogueColors.primaryDim,
    onSecondary: VogueColors.onPrimary,
    surface: VogueColors.surface,
    onSurface: VogueColors.ink,
    surfaceContainerLowest: VogueColors.surface,
    surfaceContainer: VogueColors.surfaceRaised,
    surfaceContainerHigh: VogueColors.surfaceHigh,
    surfaceContainerHighest: VogueColors.surfaceHigh,
    onSurfaceVariant: VogueColors.inkMuted,
    outline: VogueColors.outline,
    outlineVariant: VogueColors.outline,
    error: VogueColors.error,
    onError: VogueColors.ink,
  );

  return _themeFrom(
    colorScheme: colorScheme,
    brightness: Brightness.dark,
    scaffoldBackground: VogueColors.surface,
    primaryText: VogueColors.ink,
    secondaryText: VogueColors.inkMuted,
  );
}

/// Builds the light theme — paper background, ink type, cinnabar accent.
ThemeData buildVogueLightTheme() {
  const colorScheme = ColorScheme.light(
    primary: VogueColors.primary,
    onPrimary: VogueColors.paper,
    primaryContainer: Color(0xFFFBE3DA),
    onPrimaryContainer: Color(0xFF3A1F18),
    secondary: VogueColors.primaryDim,
    onSecondary: VogueColors.paper,
    surface: VogueColors.paper,
    onSurface: VogueColors.inkOnLight,
    surfaceContainerLowest: VogueColors.paper,
    surfaceContainer: VogueColors.paperRaised,
    surfaceContainerHigh: Color(0xFFE5DECC),
    surfaceContainerHighest: Color(0xFFE5DECC),
    onSurfaceVariant: VogueColors.inkMutedOnLight,
    outline: Color(0x1F181410),
    outlineVariant: Color(0x14181410),
    error: VogueColors.error,
    onError: VogueColors.paper,
  );

  return _themeFrom(
    colorScheme: colorScheme,
    brightness: Brightness.light,
    scaffoldBackground: VogueColors.paper,
    primaryText: VogueColors.inkOnLight,
    secondaryText: VogueColors.inkMutedOnLight,
  );
}

/// Shared assembly: maps a [ColorScheme] plus the token vocabulary into a
/// fully-wired [ThemeData].
ThemeData _themeFrom({
  required ColorScheme colorScheme,
  required Brightness brightness,
  required Color scaffoldBackground,
  required Color primaryText,
  required Color secondaryText,
}) {
  final textTheme = _buildTextTheme(primaryText, secondaryText);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: scaffoldBackground,
    canvasColor: scaffoldBackground,
    splashColor: colorScheme.primary.withValues(alpha: 0.10),
    highlightColor: colorScheme.primary.withValues(alpha: 0.06),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: scaffoldBackground,
      foregroundColor: primaryText,
      elevation: VogueElevation.flat,
      scrolledUnderElevation: VogueElevation.medium,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: VogueTypography.title.copyWith(color: primaryText),
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      elevation: VogueElevation.low,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VogueRadius.md),
        side: BorderSide(color: colorScheme.outline),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colorScheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: VogueElevation.high,
      modalElevation: VogueElevation.high,
      showDragHandle: true,
      dragHandleColor: colorScheme.outline,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(VogueRadius.lg),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerHigh,
      selectedColor: colorScheme.primary,
      side: BorderSide(color: colorScheme.outline),
      labelStyle: VogueTypography.label.copyWith(color: primaryText),
      secondaryLabelStyle: VogueTypography.label.copyWith(
        color: colorScheme.onPrimary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: VogueSpace.md,
        vertical: VogueSpace.sm,
      ),
      shape: const StadiumBorder(),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outline,
      thickness: 1,
      space: VogueSpace.lg,
    ),
    iconTheme: IconThemeData(color: secondaryText),
    listTileTheme: ListTileThemeData(
      iconColor: secondaryText,
      textColor: primaryText,
      contentPadding: const EdgeInsets.symmetric(horizontal: VogueSpace.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VogueRadius.sm),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.surfaceContainerHigh,
        disabledForegroundColor: secondaryText,
        elevation: VogueElevation.flat,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: VogueSpace.xl),
        textStyle: VogueTypography.label,
        shape: const StadiumBorder(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryText,
        side: BorderSide(color: colorScheme.outline),
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: VogueSpace.xl),
        textStyle: VogueTypography.label,
        shape: const StadiumBorder(),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: VogueTypography.label,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      contentTextStyle: textTheme.bodyMedium,
      actionTextColor: colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VogueRadius.sm),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: VogueColors.primary,
    ),
  );
}

/// Maps the [VogueTypography] scale onto Material's [TextTheme] slots.
TextTheme _buildTextTheme(Color primaryText, Color secondaryText) {
  return TextTheme(
    displayLarge: VogueTypography.display.copyWith(color: primaryText),
    displayMedium: VogueTypography.display.copyWith(color: primaryText),
    headlineLarge: VogueTypography.headline.copyWith(color: primaryText),
    headlineMedium: VogueTypography.headline.copyWith(color: primaryText),
    headlineSmall: VogueTypography.headline.copyWith(color: primaryText),
    titleLarge: VogueTypography.title.copyWith(color: primaryText),
    titleMedium: VogueTypography.title.copyWith(color: primaryText),
    titleSmall: VogueTypography.title.copyWith(color: secondaryText),
    bodyLarge: VogueTypography.workout.copyWith(color: primaryText),
    bodyMedium: VogueTypography.body.copyWith(color: primaryText),
    bodySmall: VogueTypography.body.copyWith(color: secondaryText),
    labelLarge: VogueTypography.label.copyWith(color: primaryText),
    labelMedium: VogueTypography.label.copyWith(color: secondaryText),
    labelSmall: VogueTypography.label.copyWith(color: secondaryText),
  );
}
