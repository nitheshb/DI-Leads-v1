import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redefineerp/Screens/Task/task_controller.dart';

class ReAssignController extends GetxController {
  var selectedIndex = 0.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final searchController = TextEditingController();
  final collection = FirebaseFirestore.instance.collection('users');
  final _collection =
      FirebaseFirestore.instance.collection('spark_assignedTasks');

  TaskController taskController = Get.find();

  var deptFilterList = <String>[].obs;
  var filterValue = 'All'.obs;
  var filterByEmployeeValue = 'ZA'.obs;
  var searchResult = ''.obs;

  RxList participantsList = [].obs;

  var participants = <Map<String, dynamic>>[].obs;

  void addParticipant(String username, String userId) {
    // Check if the participant already exists in the list
    bool participantExists =
        participants.any((participant) => participant['uid'] == userId);

    print('exists ${participantExists} ${userId}');
    print(participantsList);
    if (participantExists) {
      removeParticipant(userId);
      return;
    }

    Map<String, dynamic> newParticipant = {'name': username, 'uid': userId};
    participants.add(newParticipant);
  }

  void reAssignTo(id, name, toUid, fcm)async{

  await _collection.doc(id).update({"to_name": name, "to_uid": toUid});

  print('updated detaisl are ${id} ${name} ${toUid}');

}



  // Remove a participant from the list by their userId
  void removeParticipant(String userId) {
    participants.removeWhere((participant) => participant['uid'] == userId);
  }

  Future<void> getDeptFilterData() async {
    await collection
        .where('department', isNull: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        deptFilterList.add(doc['department'][0]);
      }
      deptFilterList.value = deptFilterList.toSet().toList();
      debugPrint('DPET LIST ${deptFilterList}');
    });
  }

  @override
  void onInit() {
    getDeptFilterData();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
