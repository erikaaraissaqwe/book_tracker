import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';

class BookDetailScreen extends StatefulWidget {
  final Book? book;

  BookDetailScreen({this.book});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _notesController;
  String _status = 'lendo';

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController = TextEditingController(text: widget.book!.title);
      _authorController = TextEditingController(text: widget.book!.author);
      _notesController = TextEditingController(text: widget.book!.notes);
      _status = widget.book!.status;
    } else {
      _titleController = TextEditingController();
      _authorController = TextEditingController();
      _notesController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveBook() async {
    if (widget.book == null) {
      // Adding new book
      Book newBook = Book(
        title: _titleController.text,
        author: _authorController.text,
        status: _status,
        notes: _notesController.text,
      );
      await Provider.of<BookProvider>(context, listen: false).addBook(newBook);
    } else {

      // Updating existing book
      Book updatedBook = Book(
        id: widget.book!.id,
        title: _titleController.text,
        author: _authorController.text,
        status: _status,
        notes: _notesController.text,
      );
      await Provider.of<BookProvider>(context, listen: false).updateBook(
          updatedBook);
    }

    // Adicionando um pequeno atraso antes de fechar a tela
    await Future.delayed(Duration(milliseconds: 100));

    // Chamando Navigator.pop após o atraso
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Salvo com sucesso!'))
    );
  }

  void _deleteBook() async {
    if (widget.book != null) {
      await Provider.of<BookProvider>(context, listen: false).deleteBook(
          widget.book!.id!);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Livro deletado com sucesso!'))
      );
    }
  }

  void _confirmDeleteBook() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Confirmar Exclusão'),
            content: Text('Tem certeza de que deseja excluir este livro?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  _deleteBook(); // Chamar o método para excluir o livro
                  Navigator.of(context).pop(); // Fechar o diálogo
                },
                child: Text('Confirmar'),
              ),
            ],
          ),
    );
  }

        @override
        Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.book == null ? 'Adicionar Livro' : 'Detalhes do Livro'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Autor'),
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['lendo', 'lido']
                    .map((status) =>
                    DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notas'),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBook,
                child: Text(widget.book == null ? 'Adicionar' : 'Salvar Alterações'),
              ),
              // Conditionally show delete button
              Visibility(
                visible: widget.book != null,
                child: ElevatedButton(
                  onPressed: _confirmDeleteBook,
                  child: Text('Excluir'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }