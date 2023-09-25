enum TasksOrderBy {
  id("id"),
  created("created"),
  updated("updated"),
  dueDate("due_date");

  final String name;

  const TasksOrderBy(this.name);
}
