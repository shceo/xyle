class LoreEntry {
  final String id;
  final String title;
  final String content;
  final int unlockAtCorrectTotal; 
  const LoreEntry({required this.id, required this.title, required this.content, required this.unlockAtCorrectTotal});
}

final List<LoreEntry> builtInLore = [
  LoreEntry(
    id: 'l1',
    title: 'Origins of XenoGlyph',
    content: 'Ancient beacons transmitted symbol-languages... (placeholder)',
    unlockAtCorrectTotal: 5,
  ),
  LoreEntry(
    id: 'l2',
    title: 'Cipher Matrices',
    content: 'Matrices map cosmological constants to phonemes...',
    unlockAtCorrectTotal: 15,
  ),
  LoreEntry(
    id: 'l3',
    title: 'The Silent Relay',
    content: 'A derelict station repeats a message every 1024 seconds...',
    unlockAtCorrectTotal: 30,
  ),
];

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String loreId; 
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.loreId,
  });
}

final List<QuizQuestion> builtInQuiz = [
  QuizQuestion(
    id: 'q1',
    loreId: 'l1',
    question: 'What powered the first Xeno beacons?',
    options: ['Stellar wind', 'Dark matter lattice', 'Quantum crystals', 'Geothermal vents'],
    correctIndex: 2,
  ),
  QuizQuestion(
    id: 'q2',
    loreId: 'l2',
    question: 'Cipher matrices map constants to...',
    options: ['Runes', 'Phonemes', 'Colours', 'Orbits'],
    correctIndex: 1,
  ),
  QuizQuestion(
    id: 'q3',
    loreId: 'l3',
    question: 'The Silent Relay repeats a message every...',
    options: ['256s', '512s', '1024s', '4096s'],
    correctIndex: 2,
  ),
];
