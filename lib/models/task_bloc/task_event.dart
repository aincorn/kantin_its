part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

}

class TaskLoadingEvent extends TaskEvent{}

class TaskCreateEvenet extends TaskEvent{
  final TableModel tableModel;
  const TaskCreateEvenet(this.tableModel);

  @override
  List<Object> get props => [tableModel];
}

class TableDeleteEvent extends TaskEvent{
  final int testId;
  const TableDeleteEvent(this.testId);

  @override
  List<Object> get props => [testId];
}