// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class DynamicDataPage extends StatefulWidget {
//   @override
//   _DynamicDataPageState createState() => _DynamicDataPageState();
// }
//
// class _DynamicDataPageState extends State<DynamicDataPage> {
//   final DatabaseReference database = FirebaseDatabase.instance.ref();
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController imageController = TextEditingController();
//   TextEditingController pdfLinkController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//
//   String? selectedCategoryId;
//   String? selectedSubCategoryId;
//
//   /// Open a dialog with dynamic fields
//   void openDialog({
//     required String title,
//     required List<Widget> fields,
//     required VoidCallback onSubmit,
//   }) {
//     nameController.clear();
//     imageController.clear();
//     pdfLinkController.clear();
//     descriptionController.clear();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(title),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: fields,
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: onSubmit,
//               child: const Text("Add"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   /// Add Category to Firebase
//   Future<void> addCategory(String name, String image) async {
//     String categoryId = database.child("category").push().key!;
//     await database.child("category/$categoryId").set({"name": name, "image": image});
//   }
//
//   /// Open Subcategory Dialog
//   void openSubCategoryDialog() {
//     openDialog(
//       title: "Add Subcategory",
//       fields: [
//         buildCategoryDropdown(),
//         TextField(controller: nameController, decoration: const InputDecoration(labelText: "Enter Name")),
//         TextField(controller: imageController, decoration: const InputDecoration(labelText: "Enter Image URL")),
//       ],
//       onSubmit: () {
//         if (selectedCategoryId != null && nameController.text.isNotEmpty) {
//           addSubCategory(selectedCategoryId!, nameController.text, imageController.text);
//           clearControllers();
//           Navigator.pop(context);
//         }
//       },
//     );
//   }
//
//   /// Add Subcategory to Firebase
//   Future<void> addSubCategory(String categoryId, String name, String image) async {
//     String subCategoryId = database.child("category/$categoryId/subcategory").push().key!;
//     await database.child("category/$categoryId/subcategory/$subCategoryId").set({"name": name, "image": image});
//   }
//
//   /// Open Sub-Subcategory Dialog
//   void openSubSubCategoryDialog() {
//     openDialog(
//       title: "Add Sub-Subcategory",
//       fields: [
//         buildCategoryDropdown(),
//         buildSubCategoryDropdown(),
//         TextField(controller: nameController, decoration: const InputDecoration(labelText: "Enter Name")),
//         TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Enter Description")),
//         TextField(controller: pdfLinkController, decoration: const InputDecoration(labelText: "Enter PDF Link")),
//       ],
//       onSubmit: () {
//         if (selectedCategoryId != null && selectedSubCategoryId != null && nameController.text.isNotEmpty) {
//           addSubSubCategory(
//             selectedCategoryId!,
//             selectedSubCategoryId!,
//             nameController.text,
//             pdfLinkController.text,
//             descriptionController.text,
//           );
//           clearControllers();
//           Navigator.pop(context);
//         }
//       },
//     );
//   }
//
//
//   void clearControllers() {
//     nameController.clear();
//     imageController.clear();
//     pdfLinkController.clear();
//     descriptionController.clear();
//     selectedCategoryId = null;
//     selectedSubCategoryId = null;
//     setState(() {});
//   }
//
//   /// Add Sub-Subcategory to Firebase
//   Future<void> addSubSubCategory(String categoryId, String subCategoryId, String name, String pdfLink, String description) async {
//     String subSubCategoryId = database.child("category/$categoryId/subcategory/$subCategoryId/sub_subcategory").push().key!;
//     await database.child("category/$categoryId/subcategory/$subCategoryId/sub_subcategory/$subSubCategoryId").set({
//       "name": name,
//       "description": description,
//       "link": pdfLink,
//     });
//   }
//
//   /// Build Category Dropdown
//   Widget buildCategoryDropdown() {
//     return StreamBuilder<DatabaseEvent>(
//       stream: database.child("category").onValue,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//           return const Text("No categories found");
//         }
//
//         Map<dynamic, dynamic> categories = Map<dynamic, dynamic>.from(
//             snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
//
//         List<DropdownMenuItem<String>> categoryItems = categories.keys
//             .map<DropdownMenuItem<String>>((categoryId) {
//           return DropdownMenuItem(
//             value: categoryId,
//             child: Text(categories[categoryId]["name"]),
//           );
//         }).toList();
//
//         if (selectedCategoryId != null && !categories.keys.contains(selectedCategoryId)) {
//           selectedCategoryId = null;
//         }
//
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return DropdownButtonFormField<String>(
//               value: selectedCategoryId,
//               hint: const Text("Select Category"),
//               items: categoryItems,
//               onChanged: (value) {
//                 setDialogState(() {
//                   selectedCategoryId = value;
//                   selectedSubCategoryId = null;
//                 });
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   /// Build Subcategory Dropdown
//   Widget buildSubCategoryDropdown() {
//     return StreamBuilder<DatabaseEvent>(
//       stream: selectedCategoryId == null
//           ? const Stream.empty()
//           : database.child("category/$selectedCategoryId/subcategory").onValue,
//       builder: (context, snapshot) {
//         if (selectedCategoryId == null) {
//           return const Text("Select category first");
//         }
//
//         if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//           return const Text("No subcategories found");
//         }
//
//         Map<dynamic, dynamic> subcategories = Map<dynamic, dynamic>.from(
//             snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
//
//         List<DropdownMenuItem<String>> subCategoryItems = subcategories.keys
//             .map<DropdownMenuItem<String>>((subCategoryId) {
//           return DropdownMenuItem(
//             value: subCategoryId,
//             child: Text(subcategories[subCategoryId]["name"]),
//           );
//         }).toList();
//
//         if (selectedSubCategoryId != null && !subcategories.keys.contains(selectedSubCategoryId)) {
//           selectedSubCategoryId = null;
//         }
//
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return DropdownButtonFormField<String>(
//               value: selectedSubCategoryId,
//               hint: const Text("Select Subcategory"),
//               items: subCategoryItems,
//               onChanged: (value) {
//                 setDialogState(() {
//                   selectedSubCategoryId = value;
//                 });
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Manage Categories")),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Center(
//           child: Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => openDialog(
//                       title: "Add Category",
//                       fields: [
//                         TextField(controller: nameController, decoration: const InputDecoration(labelText: "Enter Name")),
//                         TextField(controller: imageController, decoration: const InputDecoration(labelText: "Enter Image URL")),
//                       ],
//                       onSubmit: () {
//                         if (nameController.text.isNotEmpty) {
//                           addCategory(nameController.text, imageController.text);
//                           Navigator.pop(context);
//                         }
//                       },
//                     ),
//                     child: const Text("Add Category"),
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: openSubCategoryDialog,
//                     child: const Text("Add Subcategory"),
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: openSubSubCategoryDialog,
//                     child: const Text("Add Sub-Subcategory"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//
//   }
// }





import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DynamicDataPage extends StatefulWidget {
  @override
  _DynamicDataPageState createState() => _DynamicDataPageState();
}

class _DynamicDataPageState extends State<DynamicDataPage> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController pdfLinkController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedCategoryId;
  String? selectedSubCategoryId;

  /// Open a dialog with dynamic fields
  void openDialog({
    required String title,
    required List<Widget> fields,
    required VoidCallback onSubmit,
  }) {
    nameController.clear();
    imageController.clear();
    pdfLinkController.clear();
    descriptionController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: fields,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: onSubmit,
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  /// Add Category to Firebase
  Future<void> addCategory(String name, String image) async {
    String categoryId = database.child("category").push().key!;
    await database.child("category/$categoryId").set({"name": name, "image": image});
  }

  /// Open Subcategory Dialog
  void openSubCategoryDialog() {
    openDialog(
      title: "Add Subcategory",
      fields: [
        buildCategoryDropdown(),
        TextField(controller: nameController, decoration: const InputDecoration(labelText: "Enter Name")),
        TextField(controller: imageController, decoration: const InputDecoration(labelText: "Enter Image URL")),
      ],
      onSubmit: () {
        if (selectedCategoryId != null && nameController.text.isNotEmpty) {
          addSubCategory(selectedCategoryId!, nameController.text, imageController.text);
          clearControllers();
          Navigator.pop(context);
        }
      },
    );
  }

  /// Add Subcategory to Firebase
  Future<void> addSubCategory(String categoryId, String name, String image) async {
    String subCategoryId = database.child("category/$categoryId/subcategory").push().key!;
    await database.child("category/$categoryId/subcategory/$subCategoryId").set({"name": name, "image": image});
  }

  /// Open Sub-Subcategory Dialog
  void openSubSubCategoryDialog() {
    openDialog(
      title: "Add Sub-Subcategory",
      fields: [
        buildCategoryDropdown(),
        buildSubCategoryDropdown(),
        TextField(controller: nameController, decoration: const InputDecoration(labelText: "Enter Name")),
        TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Enter Description")),
        TextField(controller: pdfLinkController, decoration: const InputDecoration(labelText: "Enter PDF Link")),
      ],
      onSubmit: () {
        if (selectedCategoryId != null && selectedSubCategoryId != null && nameController.text.isNotEmpty) {
          addSubSubCategory(
            selectedCategoryId!,
            selectedSubCategoryId!,
            nameController.text,
            pdfLinkController.text,
            descriptionController.text,
          );
          clearControllers();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a subcategory and fill all fields")),
          );
        }
      },
    );
  }

  void clearControllers() {
    nameController.clear();
    imageController.clear();
    pdfLinkController.clear();
    descriptionController.clear();
    setState(() {
      selectedCategoryId = null;
      selectedSubCategoryId = null;
    });
  }

  /// Add Sub-Subcategory to Firebase
  Future<void> addSubSubCategory(String categoryId, String subCategoryId, String name, String pdfLink, String description) async {
    String subSubCategoryId = database.child("category/$categoryId/subcategory/$subCategoryId/sub_subcategory").push().key!;
    await database.child("category/$categoryId/subcategory/$subCategoryId/sub_subcategory/$subSubCategoryId").set({
      "name": name,
      "description": description,
      "link": pdfLink,
    });
  }

  /// Build Category Dropdown
  Widget buildCategoryDropdown() {
    return StreamBuilder<DatabaseEvent>(
      stream: database.child("category").onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Text("No categories found");
        }

        Map<dynamic, dynamic> categories = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
        List<DropdownMenuItem<String>> categoryItems = categories.keys.map<DropdownMenuItem<String>>((categoryId) {
          return DropdownMenuItem(
            value: categoryId,
            child: Text(categories[categoryId]["name"]),
          );
        }).toList();

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return DropdownButtonFormField<String>(
              value: selectedCategoryId,
              hint: const Text("Select Category"),
              items: categoryItems,
              onChanged: (value) {
                setDialogState(() {
                  selectedCategoryId = value;
                  selectedSubCategoryId = null;
                });
              },
            );
          },
        );
      },
    );
  }

  /// Build Subcategory Dropdown
  Widget buildSubCategoryDropdown() {
    return StreamBuilder<DatabaseEvent>(
      stream: selectedCategoryId == null
          ? const Stream.empty()
          : database.child("category/$selectedCategoryId/subcategory").onValue,
      builder: (context, snapshot) {
        if (selectedCategoryId == null) {
          return const Text("Select category first");
        }

        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Text("No subcategories found");
        }

        Map<dynamic, dynamic> subcategories = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
        List<DropdownMenuItem<String>> subCategoryItems = subcategories.keys.map<DropdownMenuItem<String>>((subCategoryId) {
          return DropdownMenuItem(
            value: subCategoryId,
            child: Text(subcategories[subCategoryId]["name"]),
          );
        }).toList();

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return DropdownButtonFormField<String>(
              value: selectedSubCategoryId,
              hint: const Text("Select Subcategory"),
              items: subCategoryItems,
              onChanged: (value) {
                setDialogState(() {
                  selectedSubCategoryId = value;
                });
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Categories")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () => openDialog(
                      title: "Add Category",
                      fields: [
                        TextField(controller: nameController, decoration: const InputDecoration(labelText: "Enter Name")),
                        TextField(controller: imageController, decoration: const InputDecoration(labelText: "Enter Image URL")),
                      ],
                      onSubmit: () {
                        if (nameController.text.isNotEmpty) {
                          addCategory(nameController.text, imageController.text);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    child: const Text("Add Category"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: openSubCategoryDialog, child: const Text("Add Subcategory")),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: openSubSubCategoryDialog, child: const Text("Add Sub-Subcategory")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
