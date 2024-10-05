import 'package:flutter/material.dart';
import 'package:student_detiails/Alert/delete_student.dart';
import 'package:student_detiails/db/functions/data/data_model.dart';
import 'package:student_detiails/db/functions/db_functions.dart';
import 'package:student_detiails/pages/full_details_screen.dart';

class ScreenSelect extends StatefulWidget {
  const ScreenSelect({super.key});

  @override
  State<ScreenSelect> createState() => _ScreenSelectState();
}

class _ScreenSelectState extends State<ScreenSelect> {
  late ValueNotifier<List<StudentModel>> allStudent;
  late ValueNotifier<List<bool>> isSelect;
  List<int> deletIds = [];
  @override
  void initState() {
    getAllStudent();
    allStudent =
        ValueNotifier<List<StudentModel>>(studentModelListNotifier.value);
    isSelect = ValueNotifier<List<bool>>(
        List.generate(allStudent.value.length, (index) => false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select"),
        actions: [
          IconButton(
              onPressed: () {
                print(deletIds);
                if (deletIds.isNotEmpty) {
                  Alerting.showDeleteConfirmation(
                      context: context, ids: deletIds);
                      getAllStudent();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please select any students"),
                  ));
                }
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: isSelect,
        builder: (BuildContext context, isSelected, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: allStudent,
            builder: (BuildContext context, value, Widget? child) {
              if(value.isEmpty){
                return Center(child: Text("No data"),);
              }else{
                return ListView.separated(
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            print(!isSelected[index]);
                            isSelect.value[index] = !isSelected[index];
                            isSelect.notifyListeners();
                            if (isSelected[index] == true) {
                              deletIds.add(value[index].id!);
                            } else {
                              deletIds.removeWhere((id) {
                                return id == value[index].id;
                              });
                            }
                          },
                          icon: isSelected[index] == false
                              ? Icon(Icons.check_box_outline_blank)
                              : Icon(Icons.check_box)),
                      Expanded(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    FlullDetails(data: value[index])));
                          },
                          leading: CircleAvatar(
                            backgroundImage: MemoryImage(value[index].profile),
                          ),
                          title: Text(value[index].name),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: value.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              );
              }
              
            },
          );
        },
      ),
    );
  }
}
