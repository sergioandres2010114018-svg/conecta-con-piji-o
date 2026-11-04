import 'package:flutter_test/flutter_test.dart';
import 'package:conecta_pijino/models/content.dart';

void main() {
  test('Los eventos de fecha fija calculan la próxima fecha', () {
    final e = EventItem.fromJson({
      'id': 'x',
      'titulo': 'Prueba',
      'dia': 16,
      'mes': 7,
      'fechaTexto': '16 de julio',
      'lugar': 'Pijiño',
      'descripcion': '',
      'imagen': '',
      'variable': false,
    });
    final next = e.nextDate(DateTime(2026, 11, 4));
    expect(next, DateTime(2027, 7, 16));
  });

  test('Los eventos variables no tienen fecha calculada', () {
    final e = EventItem.fromJson({
      'id': 'y',
      'titulo': 'Carnavales',
      'dia': null,
      'mes': 2,
      'fechaTexto': 'Febrero',
      'lugar': '',
      'descripcion': '',
      'imagen': '',
      'variable': true,
    });
    expect(e.nextDate(DateTime(2026, 1, 1)), isNull);
  });
}
