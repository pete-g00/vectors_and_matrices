part of '../vectors_and_matrices.dart';

class _ValueMappedMatrixRow<T extends num, V extends num> extends RowVector<V>{
  final Matrix<T> matrix;  
  final V Function(T value, int i, int j) fn;
  final int i;

  const _ValueMappedMatrixRow(this.matrix, this.fn, this.i);

  @override
  V operator [](int j) => fn(matrix.getValue(i, j), i, j);

  @override
  int get length => matrix.n;
}

class _ValueMappedMatrixCol<T extends num, V extends num> extends ColVector<V>{
  final Matrix<T> matrix;
  final V Function(T value, int i, int j) fn;
  final int j;

  const _ValueMappedMatrixCol(this.matrix, this.fn, this.j);

  @override
  V operator [](int i) => fn(matrix.getValue(i, j), i, j);

  @override
  int get length => matrix.m;
}

class _ValueMappedMatrix<T extends num, V extends num> extends Matrix<V>{
  final Matrix<T> matrix;  
  final V Function(T value, int i, int j) fn;

  const _ValueMappedMatrix(this.matrix, this.fn);

  @override
  V getValue(int i, int j) => fn(matrix.getValue(i, j), i, j);

  @override
  RowVector<V> getRow(int i) => _ValueMappedMatrixRow(matrix, fn, i);

  @override
  ColVector<V> getCol(int j) => _ValueMappedMatrixCol(matrix, fn, j);

  @override
  int get m => matrix.m;

  @override
  int get n => matrix.n;

  @override
  Iterator<Vector<V>> get iterator => rowIterator;

  @override
  int get length => matrix.m;
}
