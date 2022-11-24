import 'package:flutter/material.dart';
import 'package:flutter_codigo_taskdb/db/db_admin.dart';
import 'package:flutter_codigo_taskdb/models/task_model.dart';

class MyFormWidget extends StatefulWidget {

  TaskModel? taskModel;
  MyFormWidget({this.taskModel});

  @override
  State<MyFormWidget> createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {

  final _formKey = GlobalKey<FormState>();

  bool isFinished = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  initState(){
    super.initState();
    if(widget.taskModel != null){
      _titleController.text = widget.taskModel!.title;
      _descriptionController.text = widget.taskModel!.description;
      isFinished = widget.taskModel!.status == "true";
    }
  }


  saveTask() {
    if(_formKey.currentState!.validate()){
      TaskModel taskModel = TaskModel(
        title: _titleController.text,
        description: _descriptionController.text,
        status: isFinished.toString(),
      );
      if(widget.taskModel == null){
        DBAdmin.db.insertTask(taskModel).then((value){
          if(value > 0){
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                duration: const Duration(milliseconds: 1400),
                content: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Tarea registrada con éxito",
                    ),
                  ],
                ),
              ),
            );
          }
        });
      }else{
        taskModel.id = widget.taskModel!.id!;
        DBAdmin.db.updateTask(taskModel).then((value){
          if(value > 0){
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                duration: const Duration(milliseconds: 1400),
                content: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Tarea registrada con éxito",
                    ),
                  ],
                ),
              ),
            );
          }
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Agregar tarea"),
            const SizedBox(
              height: 6.0,
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(hintText: "Título"),
              validator: (String? value){

                if(value!.isEmpty){
                  return "El campo es obligatorio";
                }

                if(value.length < 6){
                  return "Debe de tener min 6 caracteres";
                }

                return null;
              },
            ),
            const SizedBox(
              height: 6.0,
            ),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(hintText: "Descripción"),
              validator: (String? value){
                if(value!.isEmpty){
                  return "El campo es obligatorio";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 6.0,
            ),
            Row(
              children: [
                const Text("Estado: "),
                const SizedBox(
                  width: 6.0,
                ),
                Checkbox(
                  value: isFinished,
                  onChanged: (value) {
                    isFinished = value!;
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancelar",
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    saveTask();

                  },
                  child: Text(
                    "Aceptar",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
