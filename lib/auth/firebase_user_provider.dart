import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AnimalAppFirebaseUser {
  AnimalAppFirebaseUser(this.user);
  final User user;
  bool get loggedIn => user != null;
}

AnimalAppFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<AnimalAppFirebaseUser> animalAppFirebaseUserStream() => FirebaseAuth
    .instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<AnimalAppFirebaseUser>(
        (user) => currentUser = AnimalAppFirebaseUser(user));
