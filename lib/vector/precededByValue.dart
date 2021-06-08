part of '../vectors_and_matrices.dart';

mixin _PrecededByValueMixin<T extends num> on Vector<T> {
  Vector<T> get vector;
  T get firstValue;

  @override
  int get length => vector.length + 1;

  @override
  T operator [](int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValidIndex(i, this, 'i');

    return i == 0 ? firstValue : vector[i - 1];
  }
}

class _PrecededByValueRowVector<T extends num> extends RowVector<T>
    with _PrecededByValueMixin<T> {
  @override
  final Vector<T> vector;

  @override
  final T firstValue;

  const _PrecededByValueRowVector(this.vector, this.firstValue);
}

class _PrecededByValueColVector<T extends num> extends ColVector<T>
    with _PrecededByValueMixin<T> {
  @override
  final Vector<T> vector;

  @override
  final T firstValue;

  const _PrecededByValueColVector(this.vector, this.firstValue);
}
