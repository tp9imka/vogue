// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wod_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WodSection _$WodSectionFromJson(Map<String, dynamic> json) => _WodSection(
  lines: (json['lines'] as List<dynamic>).map((e) => e as String).toList(),
  title: json['title'] as String?,
);

Map<String, dynamic> _$WodSectionToJson(_WodSection instance) =>
    <String, dynamic>{'lines': instance.lines, 'title': instance.title};
