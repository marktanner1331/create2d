import "package:test/test.dart";
import '../lib/StatefulGraphics.dart';

Future<Null> main() async {
  test("Stateful Container Test 2", () {
    Container container = Container();
    container.addLine(Line(Vertex(0, 0), Vertex(100, 100)));
    Vertex v = container.getFirstVertexUnderPoint(100, 100, 0);
    
    assert(v != null);
    expect(v.x, 100);
    expect(v.y, 100);
  });
}
