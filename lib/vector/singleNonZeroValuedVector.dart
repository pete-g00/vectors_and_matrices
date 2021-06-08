part of '../vectors_and_matrices.dart';

mixin _SingleNonZeroValuedVectorMixin<T extends num> on Vector<T> {
  int get nonZeroIndex;
  T get nonZeroValue;

  @override
  T operator [](int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, length - 1, 'i');

    return i == nonZeroIndex ? nonZeroValue : _intAsT(0);
  }

  @override
  double get magnitude => nonZeroValue.toDouble();

  @override
  int firstNonZeroIndex([int startIndex = 0]) =>
      startIndex > nonZeroIndex || nonZeroValue == 0 ? null : nonZeroIndex;

  @override
  T firstNonZeroValue([int startIndex = 0]) =>
      startIndex > nonZeroIndex || nonZeroValue == 0 ? null : nonZeroValue;

  @override
  T dotProduct(Vector<T> vector) {
    if (vector.length != length) {
      throw StateError('The length of the two vectors is different!');
    }
    return nonZeroValue * vector[nonZeroIndex];
  }
}

class _SingleNonZeroValuedRowVector<T extends num> extends RowVector<T>
    with _SingleNonZeroValuedVectorMixin<T> {
  const _SingleNonZeroValuedRowVector(
      this.length, this.nonZeroValue, this.nonZeroIndex);

  @override
  final int length;

  @override
  final int nonZeroIndex;

  @override
  final T nonZeroValue;
}

class _SingleNonZeroValuedColVector<T extends num> extends ColVector<T>
    with _SingleNonZeroValuedVectorMixin<T> {
  const _SingleNonZeroValuedColVector(
      this.length, this.nonZeroValue, this.nonZeroIndex);

  @override
  final int length;

  @override
  final int nonZeroIndex;

  @override
  final T nonZeroValue;
}
