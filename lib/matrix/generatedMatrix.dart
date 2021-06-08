part of '../vectors_and_matrices.dart';

mixin _GeneratedMatrixMixin<T extends num> on Matrix<T> {
  T Function(int i, int j) get generatorFunction;

  @override
  RowVector<T> getRow(int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, m - 1);

    return RowVector.generate(n, (j) => generatorFunction(i, j));
  }

  @override
  ColVector<T> getCol(int j) {
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n - 1);

    return ColVector.generate(m, (i) => generatorFunction(i, j));
  }

  @override
  T getValue(int i, int j) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, m - 1);
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n - 1);

    return generatorFunction(i, j);
  }

  @override
  int get length => m;

  @override
  Iterator<Vector<T>> get iterator => rowIterator;
}

class _GeneratedMatrix<T extends num> extends Matrix<T>
    with _GeneratedMatrixMixin<T> {
  @override
  final int m;

  @override
  final int n;

  @override
  final T Function(int i, int j) generatorFunction;

  const _GeneratedMatrix(this.m, this.n, this.generatorFunction);
}

class _GeneratedSquareMatrix<T extends num> extends SquareMatrix<T>
    with _GeneratedMatrixMixin<T> {
  @override
  final int n;

  @override
  final T Function(int i, int j) generatorFunction;

  const _GeneratedSquareMatrix(this.n, this.generatorFunction);
}
