enum AgeWorld {
  littleExplorers,
  tinyLearners,
  smartSorters;

  String get title => switch (this) {
    AgeWorld.littleExplorers => 'Little Explorers',
    AgeWorld.tinyLearners => 'Tiny Learners',
    AgeWorld.smartSorters => 'Smart Sorters',
  };

  String get ageLabel => switch (this) {
    AgeWorld.littleExplorers => 'Ages 1–2',
    AgeWorld.tinyLearners => 'Ages 3–5',
    AgeWorld.smartSorters => 'Ages 6–7',
  };

  String get emoji => switch (this) {
    AgeWorld.littleExplorers => '👶',
    AgeWorld.tinyLearners => '🌈',
    AgeWorld.smartSorters => '🧠',
  };

  String get subtitle => switch (this) {
    AgeWorld.littleExplorers => 'Tap, match & explore',
    AgeWorld.tinyLearners => 'Sort, categorize & play',
    AgeWorld.smartSorters => 'Reason, sort & sparkle',
  };

  String get storageKey => name;
}
