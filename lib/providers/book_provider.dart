import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_helper.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  void loadBooks() async {
    _books = await DatabaseHelper.instance.getBooks();
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    int id = await DatabaseHelper.instance.insertBook(book);
    if (id != 0) { // Verifica se o livro foi inserido com sucesso
      Book newBook = Book(
          id: id,
          title: book.title,
          author: book.author,
          status: book.status,
          notes: book.notes
      );
      _books.add(newBook);
      notifyListeners();
    }
  }

  Future<void> updateBook(Book book) async {
    int result = await DatabaseHelper.instance.updateBook(book);
    if (result != 0) { // Verifica se o livro foi atualizado com sucesso
      int index = _books.indexWhere((b) => b.id == book.id);
      if (index != -1) {
        _books[index] = book;
        notifyListeners();
      }
    }
  }

  Future<void> deleteBook(int id) async {
    int result = await DatabaseHelper.instance.deleteBook(id);
    if (result != 0) { // Verifica se o livro foi excluído com sucesso
      _books.removeWhere((book) => book.id == id);
      notifyListeners();
    }
  }
}
