import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_detiails/Alert/delete_student.dart';
import 'package:student_detiails/Alert/update_student.dart';

import 'package:student_detiails/color/colors.dart';
import 'package:student_detiails/db/functions/data/data_model.dart';
import 'package:student_detiails/db/functions/db_functions.dart';
import 'package:student_detiails/pages/full_details_screen.dart';
import 'package:student_detiails/pages/select_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  String? filter;
  //Uint8List? _webImage;
  ValueNotifier<Uint8List?> webImage = ValueNotifier(null);



  ImagePicker imagePicker = ImagePicker();



  Future<void> imagePickerFromGallery() async {
    final imgPicked = await imagePicker.pickImage(source: ImageSource.gallery);
    if (imgPicked != null) {
      final Uint8List bytes = await imgPicked.readAsBytes();
      setState(() {
        webImage.value = bytes;
      });
    }
  }

  @override
  void initState() {
    // init for Searching, Getting every letters in Search fieald
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
        
        title: const Text(
          "Students",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            onPressed: () {
              sotingBottum(context); // Show the sorting options
            },
            icon: const Icon(Icons.sort,color: Colors.white,),
          ),
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ScreenSelect()));
          }, icon: Icon(Icons.select_all,color: Colors.white,)),
          const SizedBox(width: 20,)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        //Foatting button for adding student
        onPressed: () {
          bottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              //Searching Field
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search",
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: studentModelListNotifier,
              builder: (BuildContext context, value, Widget? child) {
                List<StudentModel> filteredList = [];
                if (filter != null && filter!.isNotEmpty) {
                  filteredList = value
                      .where((student) => student.name
                          .toLowerCase()
                          .contains(filter!.toLowerCase()))
                      .toList();
                }else{
                  filteredList =value;
                }
                if(filteredList.isEmpty && value.isNotEmpty){
                  return const Center(child: Text("No Search Result"),);
                }else{
                  return ListView.separated(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FlullDetails(
                                      data: filteredList[index],
                                    )));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: MemoryImage(filteredList[index].profile),
                        ),
                        title: Text(filteredList[index].name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return UpdateStudentDetails(
                                      studentModel: filteredList[index],
                                    );
                                  }));
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  Alerting.showDeleteConfirmation(
                                      context: context, student: filteredList[index]);
                                  print(
                                      "${value[index].id} ----------------------------------");
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: filteredList.length,
                );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void bottomSheet(BuildContext context) {
    // Bottum sheet for adding studdent
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 1,
            child: SafeArea(
              child: ListView(
                children: [
                  Form(
                    key: _formKey, //Form key
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              "Add Student Details", //Bottum sheet Heading
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Stack(children: [
                            ValueListenableBuilder(
                              valueListenable: webImage,
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                return CircleAvatar(
                                    //It for display image from galary
                                    radius: 60,
                                    backgroundImage: value != null
                                        ? MemoryImage(value)
                                        : null);
                              },
                            ),
                            Positioned(
                              top: 80,
                              left: 60,
                              child: IconButton(
                                //Pick the image from galery
                                onPressed: () {
                                  imagePickerFromGallery();
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  size: 30,
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            //Text form field for Name
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the name";
                              } else {
                                return null;
                              }
                            },
                            controller: nameController,
                            decoration: const InputDecoration(
                                labelText: "Student Name"),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            //Text form field for Age
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the age";
                              } else {
                                return null;
                              }
                            },
                            controller: ageController,
                            decoration:
                                const InputDecoration(labelText: "Student Age"),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            //Text form field for Guardian Name
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the guardian name";
                              } else {
                                return null;
                              }
                            },
                            controller: fNameController,
                            decoration: const InputDecoration(
                                labelText: "Guardian Name"),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            //Text form field for Phone number
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the phone number";
                              } else if (value.length != 10) {
                                return "Please enter a valid phone number";
                              } else {
                                return null;
                              }
                            },
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                labelText: "Phone Number"),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          ElevatedButton.icon(
                            // ElevatedButton for add student
                            onPressed: () {
                              inputValidating(ctx);
                            },
                            label: const Text("Add Student"),
                            icon: const Icon(Icons.add),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  // void sotingBottum(context){
  //   showModalBottomSheet(context: context, builder: (context){
  //     return Container(
  //       width: double.infinity,
  //       child: Column(
  //         children: [
  //           SizedBox(height: 20),
  //           Container(width: double.infinity,child: TextButton(onPressed: (){
  //             studentModelListNotifier.value = studentModelListNotifier.value.sort();
  //             studentModelListNotifier.notifyListeners();
  //           }, child: Text("New on top")))
  //         ],
  //       ),
  //     );
  //   });
  // }
  void sotingBottum(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Sort by name (ascending)
                  studentModelListNotifier.value.sort((a, b) => a.name.compareTo(b.name));
                  studentModelListNotifier.notifyListeners();
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
                child: const Text("Sort by Name (A-Z)"),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Sort by name (descending)
                  studentModelListNotifier.value.sort((a, b) => b.name.compareTo(a.name));
                  studentModelListNotifier.notifyListeners();
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
                child: const Text("Sort by Name (Z-A)"),
              ),
            ),
            
          ],
        ),
      );
    },
  );
}


  //Validating all input field
  void inputValidating(ctx) {
    final sname = nameController.text;
    final sage = ageController.text;
    final gName = fNameController.text;
    final phone = phoneController.text;
    if (_formKey.currentState!.validate()) {
      final details = StudentModel(
        name: sname,
        age: sage,
        gName: gName,
        phone: phone,
        profile: webImage.value!,
      );
      addStudent(details);
      cleareTextField();
      Navigator.of(ctx).pop();
    }
  }

  // clear Text fields after submitting
  void cleareTextField() {
    nameController.clear();
    ageController.clear();
    fNameController.clear();
    phoneController.clear();
    webImage.value = null;
  }
}
