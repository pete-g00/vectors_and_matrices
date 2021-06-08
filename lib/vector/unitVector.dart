part of '../vectors_and_matrices.dart';

mixin _UnitVectorMixin<T extends num> on Vector<double> {
  Vector<T> get vector;

  @override
  int get length => vector.length;

  @override
  double get magnitude => 1.toDouble();

  @override
  double operator [](int i) => vector[i] / vector.magnitude;
}

class _UnitRowVector<T extends num> extends RowVector<double>
    with _UnitVectorMixin<T> {
  @override
  final Vector<T> vector;

  const _UnitRowVector(this.vector);
}

class _UnitColVector<T extends num> extends ColVector<double>
    with _UnitVectorMixin<T> {
  @override
  final Vector<T> vector;

  const _UnitColVector(this.vector);
}
