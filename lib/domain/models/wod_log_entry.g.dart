// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wod_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WodLogEntry _$WodLogEntryFromJson(Map<String, dynamic> json) => _WodLogEntry(
  wodKey: json['wodKey'] as String,
  doneAt: DateTime.parse(json['doneAt'] as String),
  wodDate: DateTime.parse(json['wodDate'] as String),
  branch: $enumDecode(_$BranchEnumMap, json['branch']),
  program: $enumDecode(_$ProgramEnumMap, json['program']),
  score: json['score'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$WodLogEntryToJson(_WodLogEntry instance) =>
    <String, dynamic>{
      'wodKey': instance.wodKey,
      'doneAt': instance.doneAt.toIso8601String(),
      'wodDate': instance.wodDate.toIso8601String(),
      'branch': _$BranchEnumMap[instance.branch]!,
      'program': _$ProgramEnumMap[instance.program]!,
      'score': instance.score,
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
