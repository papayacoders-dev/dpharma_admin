// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class CategoryManagementPage extends StatefulWidget {
//   @override
//   _CategoryManagementPageState createState() => _CategoryManagementPageState();
// }
//
// class _CategoryManagementPageState extends State<CategoryManagementPage> {
//   final DatabaseReference database = FirebaseDatabase.instance.ref();
//
//   void deleteCategory(String categoryId) {
//     database.child("category/$categoryId").remove();
//   }
//
//   void deleteSubCategory(String categoryId, String subCategoryId) {
//     database.child("category/$categoryId/subcategory/$subCategoryId").remove();
//   }
//
//   void deleteSubSubCategory(String categoryId, String subCategoryId, String subSubCategoryId) {
//     database.child("category/$categoryId/subcategory/$subCategoryId/sub_subcategory/$subSubCategoryId").remove();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Category Management"), backgroundColor: Colors.blueGrey),
//       body: StreamBuilder<DatabaseEvent>(
//         stream: database.child("category").onValue,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return const Center(child: Text("No categories found"));
//           }
//
//           var categories = snapshot.data!.snapshot.value as Map<dynamic, dynamic>? ?? {};
//
//           return ListView.builder(
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               String categoryId = categories.keys.elementAt(index);
//               var categoryData = categories[categoryId];
//
//               return Card(
//                 margin: EdgeInsets.all(8),
//                 child: ExpansionTile(
//                   title: Text(categoryData["name"] ?? "Unknown"),
//                   leading: Image.network(categoryData["image"] ?? "", width: 50, height: 50, fit: BoxFit.cover),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () => deleteCategory(categoryId),
//                   ),
//                   children: [
//                     if (categoryData["subcategory"] != null)
//                       ...categoryData["subcategory"].entries.map<Widget>((subCategory) {
//                         String subCategoryId = subCategory.key;
//                         var subCategoryData = subCategory.value;
//
//                         return Padding(
//                           padding: EdgeInsets.only(left: 20),
//                           child: ExpansionTile(
//                             title: Text(subCategoryData["name"] ?? "Unknown"),
//                             leading: SizedBox(width: 50,
//                                 child: Image.network(subCategoryData["image"] ?? "", width: 40, height: 40, fit: BoxFit.cover)),
//                             trailing: IconButton(
//                               icon: Icon(Icons.delete, color: Colors.red),
//                               onPressed: () => deleteSubCategory(categoryId, subCategoryId),
//                             ),
//                             children: [
//                               if (subCategoryData["sub_subcategory"] != null)
//                                 ...subCategoryData["sub_subcategory"].entries.map<Widget>((subSubCategory) {
//                                   String subSubCategoryId = subSubCategory.key;
//                                   var subSubCategoryData = subSubCategory.value;
//                                   String? link = subSubCategoryData["link"];
//
//                                   return ListTile(
//                                     title: Text(subSubCategoryData["name"] ?? "Unknown"),
//                                     subtitle: Column(
//                                       children: [
//                                         Text(subSubCategoryData["description"] ?? ""),
//                                       ],
//                                     ),
//                                     trailing: IconButton(
//                                       icon: Icon(Icons.delete, color: Colors.red),
//                                       onPressed: () => deleteSubSubCategory(categoryId, subCategoryId, subSubCategoryId),
//                                     ),
//                                   );
//                                 }).toList(),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.pop(context),
//         child: Icon(Icons.arrow_back),
//       ),
//     );
//   }
// }



import 'package:d_pharma_notes_admin/view/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
 // Import the PDF viewer screen

class CategoryManagementPage extends StatefulWidget {
  @override
  _CategoryManagementPageState createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  void deleteCategory(String categoryId) {
    database.child("category/$categoryId").remove();
  }

  void deleteSubCategory(String categoryId, String subCategoryId) {
    database.child("category/$categoryId/subcategory/$subCategoryId").remove();
  }

  void deleteSubSubCategory(String categoryId, String subCategoryId, String subSubCategoryId) {
    database.child("category/$categoryId/subcategory/$subCategoryId/sub_subcategory/$subSubCategoryId").remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Category Management")),
      body: StreamBuilder<DatabaseEvent>(
        stream: database.child("category").onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No categories found"));
          }

          var categories = snapshot.data!.snapshot.value as Map<dynamic, dynamic>? ?? {};

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              String categoryId = categories.keys.elementAt(index);
              var categoryData = categories[categoryId];

              return Card(
                margin: EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(categoryData["name"] ?? "Unknown"),
                  leading: Image.network(categoryData["image"] ?? "", width: 50, height: 50, fit: BoxFit.cover),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteCategory(categoryId),
                  ),
                  children: [
                    if (categoryData["subcategory"] != null)
                      ...categoryData["subcategory"].entries.map<Widget>((subCategory) {
                        String subCategoryId = subCategory.key;
                        var subCategoryData = subCategory.value;

                        return Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: ExpansionTile(
                            title: Text(subCategoryData["name"] ?? "Unknown"),
                            leading: SizedBox(
                              width: 50,
                              child: Image.network(subCategoryData["image"] ?? "", width: 40, height: 40, fit: BoxFit.cover),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteSubCategory(categoryId, subCategoryId),
                            ),
                            children: [
                              if (subCategoryData["sub_subcategory"] != null)
                                ...subCategoryData["sub_subcategory"].entries.map<Widget>((subSubCategory) {
                                  String subSubCategoryId = subSubCategory.key;
                                  var subSubCategoryData = subSubCategory.value;
                                  String? link = subSubCategoryData["link"];

                                  return ListTile(
                                    title: Text(subSubCategoryData["name"] ?? "Unknown"),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(subSubCategoryData["description"] ?? ""),
                                        if (link != null && link.isNotEmpty)
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PDFViewScreen(pdfUrl: link),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "View PDF",
                                              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                            ),
                                          ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => deleteSubSubCategory(categoryId, subCategoryId, subSubCategoryId),
                                    ),
                                  );
                                }).toList(),
                            ],
                          ),
                        );
                      }).toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
