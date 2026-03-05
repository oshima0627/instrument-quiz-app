import 'instrument.dart';

class Question {
  const Question({
    required this.correctInstrument,
    required this.choices,
    required this.questionNumber,
  });

  final Instrument correctInstrument;
  final List<Instrument> choices;
  final int questionNumber;
}
