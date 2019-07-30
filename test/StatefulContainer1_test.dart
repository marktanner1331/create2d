import "package:test/test.dart";
import '../lib/src/stateful_graphics/StatefulGraphics.dart';

Future<Null> main() async {
  test("Stateful Container Test 1", () {
    Container container = Container();
    container.addShape(Line(Vertex(0, 0), Vertex(100, 100)));
  });
}
