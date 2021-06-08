part of '../vectors_and_matrices.dart';

class _RowMappedMatrixColVector<T extends num, V extends num> extends ColVector<V>{
  final Matrix<T> matrix;
  final RowVector<V> Function (RowVector<T> vector, int i) fn;
  final int j;

  const _RowMappedMatrixColVector(this.matrix, this.fn, this.j);

  @override
  V operator [](int i){
    final mapped = fn(matrix.getRow(i), i);
    return mapped[j];
  }

  @override
  int get length => matrix.m;
}

class _RowMappedMatrix<T extends num, V extends num> extends Matrix<V>{
  final Matrix<T> matrix;
  final RowVector<V> Function (RowVector<T> vector, int i) fn;

  const _RowMappedMatrix(this.matrix, this.fn);

  @override
  RowVector<V> getRow(int i) => fn(matrix.getRow(i), i);

  @override
  ColVector<V> getCol(int j){
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n-1, 'j');

    return _RowMappedMatrixColVector(matrix, fn, j);
  }

  @override
  V getValue(int i, int j){
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n-1, 'j');
    
    final mapped = fn(matrix.getRow(i), i);
    return mapped[j];
  }

  @override
  int get m => matrix.m;

  @override
  int get n => matrix.n;

  @override
  int get length => matrix.m;

  @override
  Iterator<Vector<V>> get iterator => rowIterator;
}
