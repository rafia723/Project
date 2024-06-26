import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewClos extends StatefulWidget {
  final int? cid;
  final String coursename;
  final String ccode;
  const ViewClos({
    Key? key,
    required this.coursename,
    required this.ccode,
    required this.cid,
  }) : super(key: key);

  @override
  State<ViewClos> createState() => _ViewClosState();
}

class _ViewClosState extends State<ViewClos> {
  List<dynamic> clolist = [];
  bool isLoading = true;

  Future<void> loadClo(int cid) async {
    BuildContext? contextt = context; // Store the context in a local variable
    try {
      Uri uri = Uri.parse('${APIHandler().apiUrl}Clo/getCloWithApprovedStatus/$cid');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        clolist = jsonDecode(response.body);
         if (contextt.mounted) {
        setState(() {});
         isLoading = false;
         }
      } else {
        throw Exception('Failed to load clos');
      }
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: contextt,
        builder: (contextt) {
          return const AlertDialog(
            title: Text('Error loading clos'),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadClo(widget.cid!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'View Clos',
          style: TextStyle(
              fontSize: 21.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Faculty.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 30.0), // Adjust as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  widget.coursename,
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  'Course Code: ${widget.ccode}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),

              ],
            ),
          ),
            if (isLoading) // Show loading indicator if data is still loading
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                   if (!isLoading)
                Positioned(
                top: 150, // Adjust position as needed
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                children: [
                 Expanded(
                  child: ListView.builder(
                    itemCount: clolist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white10,
                        child: ListTile(
                          title: Text(
                            'Clo ${index+1}',
                            style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                          subtitle: Text(clolist[index]['clo_text'],style: const TextStyle(color: Colors.white),),
                        ),
                      );
                    },
                  ),
                ),
                customElevatedButton(onPressed: (){}, buttonText: 'Paper Settings')
                  ],
                ),
      ),
        ],
    ),   
    );
  }
}
