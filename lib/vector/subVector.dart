part of '../vectors_and_matrices.dart';

mixin _SubVectorMixin<T extends num> on Vector<T> {
  Vector<T> get vector;
  int get startIndex;
  int get endIndex;

  @override
  int get length => endIndex - startIndex;

  @override
  T operator [](int i) {
    RangeError.checkValidIndex(i, this);

    return vector[startIndex + i];
  }
}

class _SubRowVector<T extends num> extends RowVector<T>
    with _SubVectorMixin<T> {
  @override
  final Vector<T> vector;

  @override
  final int startIndex;

  @override
  final int endIndex;

  const _SubRowVector(this.vector, this.startIndex, this.endIndex);
}

class _SubColVector<T extends num> extends ColVector<T>
    with _SubVectorMixin<T> {
  @override
  final Vector<T> vector;

  @override
  final int startIndex;

  @override
  final int endIndex;

  const _SubColVector(this.vector, this.startIndex, this.endIndex);
}
