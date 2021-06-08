part of '../vectors_and_matrices.dart';

mixin _SummedVectorMixin<T extends num> on Vector<T> {
  Vector<T> get vector1;
  Vector<T> get vector2;

  @override
  T operator [](int i) => vector1[i] + vector2[i];

  @override
  int get length => vector1.length;
}

class _SummedRowVector<T extends num> extends RowVector<T>
    with _SummedVectorMixin<T> {
  @override
  final RowVector<T> vector1;

  @override
  final RowVector<T> vector2;

  const _SummedRowVector(this.vector1, this.vector2);
}

class _SummedColVector<T extends num> extends ColVector<T>
    with _SummedVectorMixin<T> {
  @override
  final ColVector<T> vector1;

  @override
  final ColVector<T> vector2;

  const _SummedColVector(this.vector1, this.vector2);
}
