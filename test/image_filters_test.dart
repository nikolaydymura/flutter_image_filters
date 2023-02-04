import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('verify available filters amount', () {
    final filters = FlutterImageFilters.availableFilters;
    expect(filters.length, 32);
  });
}
