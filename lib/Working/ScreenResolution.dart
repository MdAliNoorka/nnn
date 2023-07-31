import 'package:flutter/material.dart';
import 'dart:math';
double widthPercent(BuildContext context, double a) {
  return (MediaQuery.of(context).size.width * a) / 100.0;
}

double heightPercent(BuildContext context, double a) {
  return (MediaQuery.of(context).size.height * a) / 100.0;
}

double averagePercent(BuildContext context, double a) {
  return ((((MediaQuery.of(context).size.height +
      MediaQuery.of(context).size.width) /
      2) *
      a) /
      100.0);
}

double greaterPercent(BuildContext context, double a) {
  return (max(MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height) *
      a) /
      100.0;
}
