import 'package:flutter_test/flutter_test.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';

void main(){

  group('TaskModel tests',(){
    test('TaskModel from json test',(){
      final model = TaskModel.fromJson(const {
        'id': 4,
        'title': 'task API setup',
        'start_date': '2024-08-16T13:31:27',
        'due_date': '2024-08-16T17:31:10',
        'status': [
          {
            'id': 3,
            'name': 'todo',
            'color': '87909e',
            'is-done': false,
            'is_changable': true
          }
        ],
        'priority': [
          {'id': 1, 'name': 'normal', 'color': '6fddff'}
        ],
        'tags': [
          {'id': 6, 'name': 'WORKTAG', 'color': null}
        ],
        'list_id': 16,
        'list': [
          {'id': 16, 'name': 'NW LIST', 'color': null}
        ],
        'space_id': 1,
        'space': [
          {'id': 1, 'name': 'Main space', 'color': null}
        ],
        'folder_id': 1,
        'folder': [
          {'id': 1, 'name': 'Folder B', 'color': null}
        ],
        'workspace_id': 1,
        'workspace': [
          {'id': 1, 'name': 'my workspace', 'color': null}
        ]
      });
      print("model $model");
    });
  });
}