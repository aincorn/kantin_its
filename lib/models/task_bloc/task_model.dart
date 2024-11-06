class TableModel {
  final String testId;
  final String textTitle;  // Corrected the casing
  final String textDescription;  // Corrected the spelling
  final bool isCompleted;

  TableModel({
    required this.testId,
    required this.textTitle,
    required this.textDescription,
    required this.isCompleted,
  });

  // Create a method to toggle the completion status
  TableModel toggleCompletion() {
    return TableModel(
      testId: testId,
      textTitle: textTitle,
      textDescription: textDescription,
      isCompleted: !isCompleted,
    );
  }

  // Override toString for better readability
  @override
  String toString() {
    return 'TableModel(testId: $testId, textTitle: $textTitle, textDescription: $textDescription, isCompleted: $isCompleted)';
  }
}

