import 'package:flutter/material.dart';
import 'package:my_simple_note/model/notes.dart';
import 'package:my_simple_note/screens/home.dart';
import 'package:my_simple_note/services/database_helper.dart';

class EditNote extends StatefulWidget {
  final Note? note;
  const EditNote({this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Color _selectedColor = Colors.amber;
  final List<Color> _colors = [
    Color(0xFF2D89BF),
    Color(0xFFC02757),
    Color(0xFF2CBC4E),
    Color(0xFFEBB512),
    Color(0xFFD42C40),
    Color(0xFF808080),
    Color(0xFF2D51AB),
  ];

  @override
  void initState() {
    super.initState();
    if(widget.note != null){
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(196, 49, 4, 19),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(196, 49, 4, 19),
        iconTheme: IconThemeData(
    color: Colors.white, //change your color here
  ),
        title: Text(widget.note == null ? 'Create a Note' : 'Edit the Note', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
               Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter the title',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty) {
                          return 'Enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter the body content',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 10,
                      validator: (value){
                        if(value == null || value.isEmpty) {
                          return 'Enter the note content';
                        }
                        return null;
                      },
                    ),
                    Padding(padding: EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _colors.map(
                          (color){
                            return GestureDetector(
                              onTap: () => setState(() => _selectedColor = color),
                              child: Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: _selectedColor == color ? Colors.black45 : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    ),
                    InkWell(
                      onTap: (){
                        _saveNote();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          )
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        width: 200,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 149, 22, 65),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
               )
            ],
          ),
        )
      ),
    );
  }

  Future<void> _saveNote() async{
    if(_formKey.currentState!.validate()){
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        color: _selectedColor.value.toString(),
        dateTime: DateTime.now().toString(),
      );

      if(widget.note == null){
        await _databaseHelper.insertNote(note);
      } else {
        await _databaseHelper.updateNote(note);
      }
    }
  }
}