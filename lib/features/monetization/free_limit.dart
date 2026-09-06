import 'package:cc_core/cc_core.dart';

/// Free tier: this many systems and this much equipment, forever.
/// Live counts (rig semantics — replacing the mower shouldn't lock
/// the shed); Phase C wires the gates.
const kFreeSystemLimit = 3;
const kFreeEquipmentLimit = 2;

/// System quota with Back Forty wording.
const systemFreeLimit = FreeLimit(kFreeSystemLimit, 'systems');

/// Equipment quota ('equipment' is its own plural).
const equipmentFreeLimit = FreeLimit(kFreeEquipmentLimit, 'equipment');
