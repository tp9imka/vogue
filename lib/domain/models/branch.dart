/// A Vogue Fitness UAE location that posts a daily WOD.
enum Branch {
  /// Yas Marina.
  yasMarina('Yas Marina', 'Abu Dhabi'),

  /// Yas Ladies.
  yasLadies('Yas Ladies', 'Abu Dhabi'),

  /// Marina Mall (Mixed).
  marinaMall('Marina Mall Mixed', 'Abu Dhabi'),

  /// Al Raha.
  alRaha('Al Raha', 'Abu Dhabi'),

  /// JLT (Jumeirah Lake Towers).
  jlt('JLT', 'Dubai'),

  /// Al Ghadeer.
  alGhadeer('Al Ghadeer', 'Abu Dhabi'),

  /// Al Ain (Mixed).
  alAinMixed('Al Ain Mixed', 'Al Ain'),

  /// Al Ain Ladies.
  alAinLadies('Al Ain Ladies', 'Al Ain'),

  /// Saadiyat.
  saadiyat('Saadiyat', 'Abu Dhabi'),

  /// Stamina.
  stamina('Stamina', 'Abu Dhabi');

  const Branch(this.displayName, this.city);

  /// The branch name as shown in the UI (no `Vogue Fitness |` prefix).
  final String displayName;

  /// The emirate / city the branch sits in, used to group the picker.
  final String city;

  /// Parses a raw GravityView location string.
  ///
  /// Input looks like `Vogue Fitness | Yas Marina`; the prefix is dropped.
  /// Returns `null` for an unrecognised location.
  static Branch? fromRaw(String raw) {
    final name = raw.split('|').last.trim().toLowerCase();
    for (final branch in Branch.values) {
      if (branch.displayName.toLowerCase() == name) return branch;
    }
    return null;
  }
}
