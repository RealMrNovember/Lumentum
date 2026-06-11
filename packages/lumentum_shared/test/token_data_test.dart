import 'package:lumentum_shared/lumentum_shared.dart';
import 'package:test/test.dart';

void main() {
  test('TokenData round-trip matches contract', () {
    const original = TokenData(
      token: 'Lumentum',
      focusIndex: 2,
      paceMs: 40,
    );
    final json = original.toJson();
    final restored = TokenData.fromJson(json);

    expect(restored.token, 'Lumentum');
    expect(restored.focusIndex, 2);
    expect(restored.paceMs, 40);
  });
}
