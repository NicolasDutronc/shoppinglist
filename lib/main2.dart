void main(List<String> args) {
  testAsync();
  print("hello");
}

Future<void> testAsync() async {
  return Future.delayed(new Duration(seconds: 5))
      .then((value) => print("world"));
}
