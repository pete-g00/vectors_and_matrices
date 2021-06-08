part of '../vectors_and_matrices.dart';

mixin _FilledMatrixMixin<T extends num> on Matrix<T> {
  T get fill;

  @override
  RowVector<T> getRow(int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, m - 1, 'i');

    return RowVector.filled(n, fill);
  }

  @override
  ColVector<T> getCol(int j) {
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n - 1, 'j');

    return ColVector.filled(m, fill);
  }

  @override
  T getValue(int i, int j) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, m - 1, 'i');
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n - 1, 'j');

    return fill;
  }

  @override
  Iterator<Vector<T>> get iterator => rowIterator;

  @override
  int get rank => fill == 0 ? 0 : 1;
}

class _FilledMatrix<T extends num> extends Matrix<T>
    with _FilledMatrixMixin<T> {
  @override
  final int m;

  @override
  final int n;

  @override
  final T fill;

  const _FilledMatrix(this.m, this.n, this.fill);

  @override
  Matrix<T> scalarMultiply(T scalar) => _FilledMatrix(m, n, fill * scalar);

  @override
  int get length => m;

  @override
  Matrix<T> toREF() =>
      _GeneratedMatrix(m, n, (i, j) => i == 0 ? fill : _intAsT(0));

  @override
  Matrix<double> toRREF() =>
      _GeneratedMatrix(m, n, (i, j) => i == 0 ? rank.toDouble() : 0.toDouble());
}

class _FilledSquareMatrix<T extends num> extends SquareMatrix<T>
    with _FilledMatrixMixin<T> {
  @override
  final int n;

  @override
  final T fill;

  const _FilledSquareMatrix(this.n, this.fill);

  @override
  T get determinant => _intAsT(n == 1 ? rank : 0);

  @override
  SquareMatrix<T> scalarMultiply(T scalar) =>
      _FilledSquareMatrix(n, fill * scalar);
}
