part of '../vectors_and_matrices.dart';

mixin _FilledVectorMixin<T extends num> on Vector<T> {
  T get fill;

  @override
  T operator [](int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, length - 1, 'i');

    return fill;
  }

  @override
  double get magnitude => sqrt(length * fill * fill);

  @override
  int firstNonZeroIndex([int startIndex = 0]) =>
      startIndex < length ? startIndex : null;

  @override
  T firstNonZeroValue([int startIndex = 0]) =>
      startIndex < length ? fill : null;
}

class _FilledRowVector<T extends num> extends RowVector<T>
    with _FilledVectorMixin<T> {
  const _FilledRowVector(this.length, this.fill);

  @override
  final int length;

  @override
  final T fill;
}

class _FilledColVector<T extends num> extends ColVector<T>
    with _FilledVectorMixin<T> {
  const _FilledColVector(this.length, this.fill);

  @override
  final int length;

  @override
  final T fill;
}
