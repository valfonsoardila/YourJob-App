class TaskModel {
  String id;
  String title;
  String description;
  String dueDate;
  String status;

  TaskModel(
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.status,
  );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      json['id'],
      json['title'],
      json['description'],
      json['dueDate'],
      json['status'],
    );
  }
}
