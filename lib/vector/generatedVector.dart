part of '../vectors_and_matrices.dart';

mixin _GenerateVectorMixin<T extends num> on Vector<T> {
  T Function(int index) get fn;

  @override
  T operator [](int i) {
    RangeError.checkValueInInterval(i, 0, length - 1);

    return fn(i);
  }
}

class _GenerateRowVector<T extends num> extends RowVector<T>
    with _GenerateVectorMixin<T> {
  @override
  final int length;

  @override
  final T Function(int index) fn;

  const _GenerateRowVector(this.length, this.fn);
}

class _GenerateColVector<T extends num> extends ColVector<T>
    with _GenerateVectorMixin<T> {
  @override
  final int length;

  @override
  final T Function(int index) fn;

  const _GenerateColVector(this.length, this.fn);
}
