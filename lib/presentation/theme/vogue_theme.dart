/// `ThemeData` builders for the Vogue WOD app.
///
/// Dark is the primary theme — the app is dark-first. A light theme is
/// provided for completeness / system-setting respect, but the product is
/// designed and tuned against dark.
///
/// These builders wire the token classes (`VogueColors`, `VogueSpace`,
/// `VogueRadius`, `VogueElevation`) and the `VogueTypography` scale into a
/// single `ThemeData`, so feature code only ever touches `Theme.of(context)`.
library;

import 'package:flutter/material.dart';
import 'package:vogue_wod/presentation/theme/vogue_tokens.dart';
import 'package:vogue_wod/presentation/theme/vogue_typography.dart';

/// Builds the primary dark theme for the Vogue WOD app.
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
    onError: VogueColors.onSemantic,
  );

  return _themeFrom(
    colorScheme: colorScheme,
    brightness: Brightness.dark,
    scaffoldBackground: VogueColors.surface,
    primaryText: VogueColors.ink,
    secondaryText: VogueColors.inkMuted,
  );
}

/// Builds a light theme — provided so the app honours a light system
/// setting. The product is designed dark-first; this is a faithful fallback.
ThemeData buildVogueLightTheme() {
  const surface = Color(0xFFF6F7F9);
  const surfaceRaised = Color(0xFFFFFFFF);
  const surfaceHigh = Color(0xFFEDEFF2);
  const ink = Color(0xFF14171C);
  const inkMuted = Color(0xFF565E6B);
  const outline = Color(0xFFD6DAE0);

  const colorScheme = ColorScheme.light(
    primary: VogueColors.primaryDim,
    onPrimary: VogueColors.onPrimary,
    primaryContainer: Color(0xFFEAF6C4),
    onPrimaryContainer: Color(0xFF31420A),
    secondary: VogueColors.primary,
    onSecondary: VogueColors.onPrimary,
    surface: surface,
    onSurface: ink,
    surfaceContainerLowest: surface,
    surfaceContainer: surfaceRaised,
    surfaceContainerHigh: surfaceHigh,
    surfaceContainerHighest: surfaceHigh,
    onSurfaceVariant: inkMuted,
    outline: outline,
    outlineVariant: outline,
    error: VogueColors.error,
    onError: VogueColors.onSemantic,
  );

  return _themeFrom(
    colorScheme: colorScheme,
    brightness: Brightness.light,
    scaffoldBackground: surface,
    primaryText: ink,
    secondaryText: inkMuted,
  );
}

/// Shared assembly: maps a [ColorScheme] plus the token vocabulary into a
/// fully-wired [ThemeData]. Keeps the two public builders thin and identical
/// in structure.
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
    splashColor: colorScheme.primary.withValues(alpha: 0.12),
    highlightColor: colorScheme.primary.withValues(alpha: 0.08),
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
      secondaryLabelStyle:
          VogueTypography.label.copyWith(color: colorScheme.onPrimary),
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
