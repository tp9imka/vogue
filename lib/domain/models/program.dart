/// The kinds of programming a Vogue Fitness branch posts as a WOD.
enum Program {
  /// VogueFit — the main group class.
  vogueFit('VogueFit'),

  /// Metcon — metabolic conditioning.
  metcon('Metcon'),

  /// Generic workout of the day.
  wod('WOD'),

  /// Speciality — focused skill work (Olympic lifting, gymnastics…).
  speciality('Speciality'),

  /// Stamina — endurance-focused programming.
  stamina('Stamina')
  ;

  const Program(this.label);

  /// The display label, matching the source site's wording.
  final String label;

  /// Maps a raw GravityView program string to a [Program].
  ///
  /// Case-insensitive; unknown values fall back to [Program.wod].
  static Program fromRaw(String raw) {
    final value = raw.trim().toLowerCase();
    for (final program in Program.values) {
      if (program.label.toLowerCase() == value) return program;
    }
    return Program.wod;
  }
}
