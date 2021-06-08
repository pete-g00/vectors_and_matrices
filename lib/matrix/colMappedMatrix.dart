part of '../vectors_and_matrices.dart';

class _ColMappedMatrixRow<T extends num, V extends num> extends RowVector<V> {
  final Matrix<T> matrix;
  final ColVector<V> Function(ColVector<T> vector, int j) fn;
  final int i;

  const _ColMappedMatrixRow(this.matrix, this.fn, this.i);

  @override
  V operator [](int j) {
    final mapped = fn(matrix.getCol(j), j);
    return mapped[i];
  }

  @override
  int get length => matrix.n;
}

class _ColMappedMatrix<T extends num, V extends num> extends Matrix<V> {
  final Matrix<T> matrix;
  final ColVector<V> Function(ColVector<T> vector, int j) fn;

  const _ColMappedMatrix(this.matrix, this.fn);

  @override
  RowVector<V> getRow(int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, m - 1, 'i');

    return _ColMappedMatrixRow(matrix, fn, i);
  }

  @override
  int get length => matrix.n;

  @override
  Iterator<Vector<V>> get iterator => colIterator;

  @override
  ColVector<V> getCol(int j) => fn(matrix.getCol(j), j);

  @override
  V getValue(int i, int j) {
    final mapped = fn(matrix.getCol(j), j);
    return mapped[i];
  }

  @override
  int get m => matrix.m;

  @override
  int get n => matrix.n;
}
