import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

// class DbSupa {
//   static DbSupa get instanace => DbSupa();

//   late final SupabaseClient _supabaseClient;

//   void initialize(SupabaseClient supabaseClient) {
//     _supabaseClient = supabaseClient;
//   }

class DbSupa {
  static DbSupa get instance => DbSupa._();

  late final SupabaseClient _supabaseClient;
  var supabaseClient = GetIt.instance<SupabaseClient>();

  DbSupa._();

  void initialize(SupabaseClient supabaseClient) {
    _supabaseClient = supabaseClient;
  }

  void createTask(obj) async {
    print('received obj is ${obj}');
    final client = GetIt.instance<SupabaseClient>();
    final response = await client.from('maahomes_TM_Tasks').insert({
      'created_on': obj["created_on"],
      'title': obj["task_title"],
      'by_email': obj["by_email"],
      'by_name': obj["by_name"],
      'by_uid': obj["by_uid"],
      'dept': obj["dept"],
      'due_date': obj["due_date"],
      'priority': obj["priority"],
      'status': obj["status"],
      'desc': obj["desc"],
      'to_email': obj["to_email"],
      'to_name': obj["to_name"],
      'to_uid': obj["to_uid"],
      'participantsA': obj["participantsA"]
    });

    if (response.error != null) {
      print(response);
    } else {
      print('Task inserted successfully');
    }
  }

  void saveNotification(userId, content, taskId) async {
    final response = await supabaseClient.from('taskman_notifications').insert({
      'user_id': userId,
      'content': content,
      'task_id': taskId,
    });

    print(response);

    // if (response.error != null) {
    //   print(response);
    // } else {
    //   print('Notification saved  successfully');
    // }
  }
}
