enum Difficulty { easy, normal, hard }

extension DifficultyExt on Difficulty {
  int get choiceCount => switch (this) {
        Difficulty.easy => 2,
        Difficulty.normal => 3,
        Difficulty.hard => 4,
      };

  String get displayName => switch (this) {
        Difficulty.easy => 'かんたん',
        Difficulty.normal => 'ふつう',
        Difficulty.hard => 'むずかしい',
      };
}
