import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_detiails/db/functions/data/data_model.dart';
import 'package:student_detiails/db/functions/db_functions.dart';

class UpdateStudentDetails extends StatefulWidget {
  StudentModel studentModel;

  UpdateStudentDetails({super.key, required this.studentModel});

  @override
  State<UpdateStudentDetails> createState() => _UpdateStudentDetailsState();
}

class _UpdateStudentDetailsState extends State<UpdateStudentDetails> {
  late TextEditingController nameController;
  //Uint8List? profilePathController;
  late TextEditingController ageController;
  late TextEditingController fNameController;
  late TextEditingController phoneController;
  final _formKey = GlobalKey<FormState>();
  @override
  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    fNameController.dispose();
    phoneController.dispose();
    //profilePathController.dispose();

    super.dispose();
  }

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

  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.studentModel.name);
    ageController = TextEditingController(text: widget.studentModel.age);
    fNameController = TextEditingController(text: widget.studentModel.gName);
    phoneController = TextEditingController(text: widget.studentModel.phone);
    webImage.value = widget.studentModel.profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, //Form key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(children: [
                ValueListenableBuilder(
                  valueListenable: webImage,
                  builder: (BuildContext context, value, Widget? child) {
                    return CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          value != null ? MemoryImage(value) : null,
                    );
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
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (val){
                    if(val == null || val.isEmpty){
                      return "Please Enter Student Name";
                    }else{
                      return null;
                    }
                  },
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Student Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (val){
                    if(val ==null || val.isEmpty){
                      return "Please Enter Age";
                    }else{
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  controller: ageController,
                ),
              ),
              //Father name
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (val){
                    if(val==null || val.isEmpty){
                      return "Please Enter Father Name";
                    }else{
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: "Father Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  controller: fNameController,
                ),
              ),
              //Phone number
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (val){
                    if(val !is int || val.length!=10){
                      return "Please Enter Valide Number";
                    }else{
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  controller: phoneController,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    //await updateStudentDetails();
                    inputValidating(context);
                  },
                  child: const Text("Update"))
            ],
          ),
        ),
      ),
    );
  }

// Success fully updated snack bar
  void updateSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        elevation: 6.0,
        backgroundColor: Color.fromARGB(255, 76, 190, 80),
        content: Text("Student details hase updated"),
      ),
    );
  }

  //Validating all input field
  void inputValidating(ctx) {
    if (_formKey.currentState!.validate()) {
      final student = StudentModel(
          name: nameController.text,
          age: ageController.text,
          gName: fNameController.text,
          phone: phoneController.text,
          profile: webImage.value!,
          id: widget.studentModel.id);
      updateStudent(student);
      Navigator.of(context).pop();
      updateSnack(context);
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
