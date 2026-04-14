import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';
import 'package:mgw_eva/features/wiki/logic/wiki_list_providers.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

final weaponDetailProvider = FutureProvider.autoDispose.family<Weapon?, int>((
  Ref ref,
  int weaponId,
) async {
  debugPrint('[WeaponDetail] route weaponId=$weaponId');
  final Weapon? weapon = await ref
      .watch(weaponRepositoryProvider)
      .getWeaponById(weaponId);
  debugPrint(
    '[WeaponDetail] repository result='
    '${weapon == null ? 'null' : '${weapon.id}:${weapon.name}'}',
  );
  return weapon;
});

final relatedWeaponsProvider = Provider.autoDispose
    .family<AsyncValue<List<Weapon>>, int>((Ref ref, int weaponId) {
      final AsyncValue<List<Weapon>> weapons = ref.watch(wikiWeaponsProvider);

      return weapons.whenData((List<Weapon> items) {
        final List<Weapon> related = items
            .where((Weapon weapon) => weapon.id != weaponId)
            .take(6)
            .toList();
        debugPrint(
          '[WeaponDetail] related weapons for=$weaponId count=${related.length}',
        );
        return related;
      });
    });
