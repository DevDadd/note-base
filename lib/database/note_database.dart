import 'package:isar/isar.dart';
import 'package:notetaking/model/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase {
  static late Isar isar;
  // INITIALIZE DB
  static Future<void> initializeDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  final List<Note> currentNotes = [];

  // CREATE
  Future<void> addNotes(String textFromUser) async {
    final newNote = Note()..text = textFromUser;
    await isar.writeTxn(() => isar.notes.put(newNote));
    fetchNotes();
  }

  // READ
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
  }

  // UPDATE
  Future<void> updateNotes(int id, String text) async {
    final note1 = await isar.notes.get(id);
    if (note1 != null) {
      note1.text = text;
      await isar.writeTxn(() => isar.notes.put(note1));
      await fetchNotes();
    }
  }

  // DELETE

  Future<void> deleteNotes(int id) async {
    final noteNow = await isar.notes.get(id);
    if (noteNow != null) {
      await isar.writeTxn(() => isar.notes.delete(id));
      await fetchNotes();
    }
  }
}
