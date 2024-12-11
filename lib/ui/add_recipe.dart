import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resepmakanan_5b/services/recipe_service.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final RecipeService _RecipeService = RecipeService();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      final result = await _RecipeService.submitData(
        _titleController.text,
        _methodController.text,
        _ingredientsController.text,
        _descriptionController.text,
        _selectedImage!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Unknown error')),
      );

      if (result['status']) {
        _formKey.currentState!.reset();
        setState(() {
          _selectedImage = null;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and select an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Title is required'
                      : null,
                ),
                TextFormField(
                  controller: _methodController,
                  decoration: InputDecoration(labelText: 'Cooking Method'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Cooking Method is required'
                      : null,
                ),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: InputDecoration(labelText: 'Ingredients'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Ingredients are required'
                      : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Description is required'
                      : null,
                ),
                SizedBox(height: 16),
                _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Text('No image selected'),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.image),
                  label: Text('Pick Image'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await _submit(); 
                    Navigator.pop(
                        context, true); 
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
