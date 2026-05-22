import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/branch.dart';

/// Persists the user's favorite [Branch] across launches.
class FavoriteBranchStore {
  static const _key = 'favorite_branch';

  /// Reads the saved favorite branch, or `null` if none was ever set.
  Future<Branch?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    if (name == null) return null;
    return Branch.values.where((b) => b.name == name).firstOrNull;
  }

  /// Saves [branch] as the favorite branch.
  Future<void> write(Branch branch) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, branch.name);
  }
}
