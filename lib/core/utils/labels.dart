import '../../data/database/app_database.dart';

extension SystemKindLabel on SystemKind {
  String get label => switch (this) {
        SystemKind.well => 'Well',
        SystemKind.septic => 'Septic',
        SystemKind.generator => 'Generator',
        SystemKind.softener => 'Water softener',
        SystemKind.sumpPump => 'Sump pump',
        SystemKind.waterHeater => 'Water heater',
        SystemKind.hvac => 'HVAC',
        SystemKind.other => 'Other',
      };
}

extension EquipmentKindLabel on EquipmentKind {
  String get label => switch (this) {
        EquipmentKind.boat => 'Boat',
        EquipmentKind.outboard => 'Outboard',
        EquipmentKind.snowblower => 'Snowblower',
        EquipmentKind.mower => 'Mower',
        EquipmentKind.tractor => 'Tractor',
        EquipmentKind.sprinklerSystem => 'Sprinkler system',
        EquipmentKind.hotTub => 'Hot tub',
        EquipmentKind.pressureWasher => 'Pressure washer',
        EquipmentKind.chainsaw => 'Chainsaw',
        EquipmentKind.generatorPortable => 'Portable generator',
        EquipmentKind.other => 'Other',
      };
}

extension ServiceKindLabel on ServiceKind {
  String get label => switch (this) {
        ServiceKind.service => 'Service',
        ServiceKind.repair => 'Repair',
        ServiceKind.inspection => 'Inspection',
        ServiceKind.filterChange => 'Filter change',
        ServiceKind.saltFill => 'Salt fill',
        ServiceKind.pumpOut => 'Pump-out',
        ServiceKind.oilChange => 'Oil change',
        ServiceKind.bladeSharpen => 'Blade sharpen',
        ServiceKind.winterize => 'Winterize',
        ServiceKind.springStart => 'Spring start',
        ServiceKind.other => 'Other',
      };
}

extension IntervalSeasonLabel on IntervalSeason {
  String get label => switch (this) {
        IntervalSeason.fall => 'Every fall (Oct 1)',
        IntervalSeason.spring => 'Every spring (Apr 1)',
      };
}

extension ChecklistSeasonLabel on ChecklistSeason {
  String get label => switch (this) {
        ChecklistSeason.storeFall => 'Fall storage',
        ChecklistSeason.startSpring => 'Spring start',
      };
}

/// The system's kind for display — the user's own word when `other`.
String systemKindLabel(System s) => s.kind == SystemKind.other
    ? (s.kindLabel ?? SystemKind.other.label)
    : s.kind.label;

/// The equipment's kind for display.
String equipmentKindLabel(EquipmentData e) => e.kind == EquipmentKind.other
    ? (e.kindLabel ?? EquipmentKind.other.label)
    : e.kind.label;

/// The event's kind for display.
String serviceKindLabel(ServiceEvent e) => e.kind == ServiceKind.other
    ? (e.kindLabel ?? ServiceKind.other.label)
    : e.kind.label;

/// Kind-aware quick-fill: what a service composer preselects for this
/// owner ("log service on the septic" starts at Pump-out). Just a
/// default — every kind stays pickable.
ServiceKind defaultServiceKind({SystemKind? system, EquipmentKind? equipment}) {
  if (system != null) {
    return switch (system) {
      SystemKind.septic => ServiceKind.pumpOut,
      SystemKind.softener => ServiceKind.saltFill,
      SystemKind.well => ServiceKind.filterChange,
      SystemKind.hvac => ServiceKind.filterChange,
      _ => ServiceKind.service,
    };
  }
  return switch (equipment) {
    EquipmentKind.mower ||
    EquipmentKind.tractor ||
    EquipmentKind.outboard ||
    EquipmentKind.generatorPortable =>
      ServiceKind.oilChange,
    EquipmentKind.chainsaw => ServiceKind.bladeSharpen,
    _ => ServiceKind.service,
  };
}
