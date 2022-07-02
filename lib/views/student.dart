import 'dart:math';

import 'package:demo/controllers/database_con.dart';
import 'package:demo/models/student_mod.dart';
import 'package:flutter/material.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController subject = TextEditingController();

  Random i = Random();
  bool loading = false;
  int? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stduents'),
      ),
      body: Column(
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(
              hintText: 'Enter name'
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            controller: subject,
            decoration: const InputDecoration(
                hintText: 'Enter subject'
            ),
          ),
          const SizedBox(height: 20,),
          loading? const CircularProgressIndicator():
          ElevatedButton(
              onPressed: ()async{
                setState(()=>loading=true);
                final student = StudentModel(
                  id: i.nextInt(100),
                  name: name.text,
                  subject: subject.text
                );
                await DataBaseController.instance.addData(student);
                setState(()=>loading = false);
              },
              child: const Text('Submit')
          ),

          loading? const CircularProgressIndicator():
          ElevatedButton(
              onPressed: ()async{
                setState(()=>loading=true);
                final students = StudentModel(
                  id: id,
                  name: name.text,
                  subject: subject.text
                );
                await DataBaseController.instance.updateData(students);
                setState(()=>loading = false);
              },
              child: const Text('Update')
          ),

          Expanded(
              child: FutureBuilder(
                future: DataBaseController.instance.getData(),
                  builder: (BuildContext context, AsyncSnapshot<List<StudentModel>> snapshot){
                  return snapshot.data!.isEmpty? const Text('no recorde found'):ListView(
                    children: snapshot.data!.map((e) => ListTile(
                      leading: IconButton(
                          onPressed: ()async{
                            setState((){
                              id = e.id;
                              name.text = e.name!;
                              subject.text = e.subject!;
                            });
                          },
                          icon: Icon(Icons.delete,color: Colors.redAccent,)
                      ),
                      title: Text(e.name!),
                      subtitle: Text(e.subject!),
                      trailing: loading?CircularProgressIndicator():
                      IconButton(
                          onPressed: ()async{
                            setState((){
                              loading=true;
                            });
                            await DataBaseController.instance.deleteData(e.id!);
                            setState((){
                              loading=false;
                            });
                          },
                          icon: Icon(Icons.delete,color: Colors.redAccent,)
                      ),
                    )).toList(),
                  );
                  }
              )
          )
        ],
      ),
    );
  }
}
