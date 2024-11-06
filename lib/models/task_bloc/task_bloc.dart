import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import "task_model.dart";

part 'task_event.dart';
part 'task_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(const TableInitial()) {
    on<TableDeleteEvent>((event, emit) {
      if (event is TableDeleteEvent) {
        emit(TableInitial());
      }
    });
  }
}

onTaskLoadingEvent(event, emit) {
  emit(TaskLoading());

  emit(TaskLoaded(task: const Task()));

  // Create
  onTaskCreateEvent (event, emit) {
    emit(TaskLoaded(task: const Task()));
  }

  List<TableModel> updateModel = List.from([event.task]);
}