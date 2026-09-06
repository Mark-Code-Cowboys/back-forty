import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/home_screen.dart';
import '../intervals/whats_due_screen.dart';
import '../monetization/free_limit.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import '../owners/equipment_composer_screen.dart';
import '../owners/system_composer_screen.dart';
import '../trends/trends_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  var _index = 0;

  static const _screens = [HomeScreen(), WhatsDueScreen(), TrendsScreen()];

  /// Both adds gate on LIVE counts (rig semantics — replacing the
  /// mower or the well frees the slot); unlocking mid-flow continues
  /// into the composer.
  Future<void> _add() async {
    final which = await showModalBottomSheet<Type>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.cabin_outlined),
              title: const Text('Add a system'),
              subtitle: const Text('Well, septic, generator — the fixed '
                  'things the house depends on.'),
              onTap: () =>
                  Navigator.of(context).pop(SystemComposerScreen),
            ),
            ListTile(
              leading: const Icon(Icons.agriculture_outlined),
              title: const Text('Add equipment'),
              subtitle: const Text(
                  'Boat, snowblower, mower — the seasonal fleet.'),
              onTap: () =>
                  Navigator.of(context).pop(EquipmentComposerScreen),
            ),
          ],
        ),
      ),
    );
    if (which == null || !mounted) return;
    final entitled =
        await ref.read(entitlementServiceProvider).isUnlimited();
    final isSystem = which == SystemComposerScreen;
    final used = isSystem
        ? (await ref.read(allSystemsProvider.future)).length
        : (await ref.read(allEquipmentProvider.future)).length;
    final limit = isSystem ? systemFreeLimit : equipmentFreeLimit;
    try {
      limit.guard(used: used, entitled: entitled);
    } on FreeLimitReachedException {
      if (!mounted) return;
      final unlocked = await showPaywallSheet(context);
      if (!unlocked) return;
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => which == SystemComposerScreen
            ? const SystemComposerScreen()
            : const EquipmentComposerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: _add,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.cabin_outlined), label: 'Property'),
          NavigationDestination(
              icon: Icon(Icons.pending_actions_outlined),
              label: "What's due"),
          NavigationDestination(
              icon: Icon(Icons.insights_outlined), label: 'Trends'),
        ],
      ),
    );
  }
}
