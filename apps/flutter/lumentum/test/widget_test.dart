import 'package:flutter_test/flutter_test.dart';
import 'package:lumentum_shared/lumentum_shared.dart';

void main() {
  test('TokenData from shared package', () {
    const token = TokenData(token: 'test', focusIndex: 1, paceMs: 40);
    expect(token.token, 'test');
  });
}
