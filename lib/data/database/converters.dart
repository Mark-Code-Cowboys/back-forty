import 'dart:convert';

import 'package:drift/drift.dart';

/// Freeform spec sheet: label -> value, in the order the user entered
/// ("GPM" -> "12", "Filter" -> "FXHTC"). Stored as a JSON object.
class SpecsConverter extends TypeConverter<Map<String, String>, String> {
  const SpecsConverter();

  @override
  Map<String, String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as Map<String, dynamic>).cast<String, String>();

  @override
  String toSql(Map<String, String> value) => jsonEncode(value);
}

/// One line of a seasonal checklist.
class ChecklistStep {
  const ChecklistStep({required this.label, this.done = false, this.note});

  final String label;
  final bool done;

  /// The year-to-year wisdom ("fogging oil is in the red cabinet").
  final String? note;

  ChecklistStep copyWith({String? label, bool? done, String? note}) =>
      ChecklistStep(
        label: label ?? this.label,
        done: done ?? this.done,
        note: note ?? this.note,
      );

  Map<String, Object?> toJson() =>
      {'label': label, 'done': done, 'note': note};

  factory ChecklistStep.fromJson(Map<String, dynamic> json) => ChecklistStep(
        label: json['label'] as String,
        done: json['done'] as bool? ?? false,
        note: json['note'] as String?,
      );
}

/// The checklist's steps, in order. Stored as a JSON array.
class ChecklistStepsConverter
    extends TypeConverter<List<ChecklistStep>, String> {
  const ChecklistStepsConverter();

  @override
  List<ChecklistStep> fromSql(String fromDb) => [
        for (final step in jsonDecode(fromDb) as List)
          ChecklistStep.fromJson(step as Map<String, dynamic>),
      ];

  @override
  String toSql(List<ChecklistStep> value) =>
      jsonEncode([for (final s in value) s.toJson()]);
}
