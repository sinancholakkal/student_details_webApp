

import 'package:flutter/material.dart';
import 'package:student_detiails/db/functions/data/data_model.dart';
import 'package:student_detiails/db/functions/db_functions.dart';

class Alerting{
   static void showDeleteConfirmation({required BuildContext context, StudentModel? student,List<int>? ids}) {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if(student==null){
                  deleteMultiItem(ids!);
                }else{
                  deleteStudent(student.id);
                }
                
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}