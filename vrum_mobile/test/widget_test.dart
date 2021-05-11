// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

import 'package:vrum_mobile/main.dart';

void main() {

  test('distance', () {
    expect(SphericalUtil.computeDistanceBetween(LatLng(40.059182, -105.215997), LatLng(40.059919, -105.211947)), closeTo(350, 10));
  });

  test('bearing', () {
    expect(SphericalUtil.computeHeading(LatLng(40.059182, -105.215997), LatLng(40.059919, -105.211947)), closeTo(75, 10));
  });
}
