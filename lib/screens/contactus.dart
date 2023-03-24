import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:convert';
import '../home.dart';
import 'package:lottie/lottie.dart';
import 'package:ctse_app/services/validators.dart';

class ContactScreen extends StatefulWidget{
  const ContactScreen({Key? key}) : super(key:key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

final nameController = TextEditingController();
final subjectController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();
  final List<String> _priorities = ['Critical', 'Not Satisfied', 'Somewhat Satisfied', 'Satisfied','Perfect'];
  String _selectedPriority = 'Perfect';

  Color _getColorForPriority(String priority) {
    // return color based on priority
    if (priority == 'Critical') {
      return Colors.red;
    } else if (priority == 'Not Satisfied') {
      return Color.fromARGB(255, 255, 106, 0);
    } else if (priority == 'Somewhat Satisfied') {
      return Colors.orange;
    }else if (priority == 'Satisfied') {
      return Color.fromARGB(255, 255, 251, 0);
    }else {
      return Colors.green;
    }
  }

Future sendEmail() async{
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  const serviceId ="service_9as2fqk";
  const templateId ="template_9uzcgs2";
  const userId ="vWgbn1TRXpRzDhYZE";
  final response = await http.post(url,
  headers: {'Content-Type': 'application/json','origin':'http://localhost'},
  body: json.encode({
    "service_id":serviceId,
    "template_id":templateId,
    "user_id": userId,
    "template_params":{
      "name":nameController.text,
      "priority":_selectedPriority,
      "subject": subjectController.text,
      "message": messageController.text,
      "user_email":emailController.text
       
    }
  })
  );
 return response.statusCode;
}

Future<void>_handleRefresh()async{
  //reload takes some time
  return await Future.delayed(Duration(seconds: 2));
}


class _ContactScreenState extends State<ContactScreen>{
  @override
  Widget build (BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
         title: Text("Contact Us"),
        backgroundColor: Colors.purple.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Main())),
        ),
      ),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        child: Column(children: [
         
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              icon: const Icon(Icons.account_circle),
              hintText: 'Enter your Name',
              labelText: 'Name',
            ),
            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Name';
                              }
                              if (!value.isValidName()) {
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
          ),
          SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: subjectController,
            decoration: const InputDecoration(
              icon: const Icon(Icons.subject_rounded),
              hintText: 'Subject',
              labelText: 'Subject',
            ),
            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please a Subject';
                              }
                              
                              return null;
                            },
          ),
          SizedBox(
            height: 25,
          ),
         TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              icon: const Icon(Icons.email),
              hintText: 'Enter your Email',
              labelText: 'Email',
            ),
            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter an email';
                              }
                              if (!value.isValidEmail()) {
                                return 'Enter Valid Email';
                              }
                              return null;
                            },
          ), 
          SizedBox(
            height: 25,
          ),
         TextFormField(
            controller: messageController,
            decoration: const InputDecoration(
              icon: const Icon(Icons.message),
              hintText: 'Message',
              labelText: 'Message',
            ),
          ),
           SizedBox(
            height: 30,
          ),
           const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'User Feedback Level',
                      border: OutlineInputBorder(),
                    ),
                    items: _priorities
                        .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: _getColorForPriority(priority),
                                  ),
                                ),
                                Text(priority),
                              ],
                            )))
                        .toList(),
                  ),
          ElevatedButton(
            onPressed: (){
                sendEmail();
                nameController.text = "";
                subjectController.text= "";
                messageController.text= "";
                emailController.text= "";
      
            },
            child: Text(
              "Send",
              style: TextStyle(fontSize: 20),
            ),
            
            ),
             Lottie.network('https://assets5.lottiefiles.com/packages/lf20_HxqVQ4.json'),
        ],
        )),
      ),
      ),
    );
  }
}
