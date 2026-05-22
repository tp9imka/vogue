// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Wod _$WodFromJson(Map<String, dynamic> json) => _Wod(
  date: DateTime.parse(json['date'] as String),
  branch: $enumDecode(_$BranchEnumMap, json['branch']),
  program: $enumDecode(_$ProgramEnumMap, json['program']),
  sections: (json['sections'] as List<dynamic>)
      .map((e) => WodSection.fromJson(e as Map<String, dynamic>))
      .toList(),
  note: json['note'] as String?,
);

Map<String, dynamic> _$WodToJson(_Wod instance) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'branch': _$BranchEnumMap[instance.branch]!,
  'program': _$ProgramEnumMap[instance.program]!,
  'sections': instance.sections.map((e) => e.toJson()).toList(),
  'note': instance.note,
};

const _$BranchEnumMap = {
  Branch.yasMarina: 'yasMarina',
  Branch.yasLadies: 'yasLadies',
  Branch.marinaMall: 'marinaMall',
  Branch.alRaha: 'alRaha',
  Branch.jlt: 'jlt',
  Branch.alGhadeer: 'alGhadeer',
  Branch.alAinMixed: 'alAinMixed',
  Branch.alAinLadies: 'alAinLadies',
  Branch.saadiyat: 'saadiyat',
  Branch.stamina: 'stamina',
};

const _$ProgramEnumMap = {
  Program.vogueFit: 'vogueFit',
  Program.metcon: 'metcon',
  Program.wod: 'wod',
  Program.speciality: 'speciality',
  Program.stamina: 'stamina',
};
