class EditProjectPageArgs {
  const EditProjectPageArgs({
    required this.id,
    required this.name,
    required this.description,
    required this.due,
  });

  final String id;
  final String name;
  final String? description;
  final DateTime due;
}
