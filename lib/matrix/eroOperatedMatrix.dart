part of '../vectors_and_matrices.dart';

class _EROOperatedRowVector<T extends num> extends RowVector<T> {
  final Matrix<T> matrix;
  final ERO<T> ero;
  final int i;

  const _EROOperatedRowVector(this.matrix, this.ero, this.i);

  @override
  T operator [](int j) => ero.getValue(matrix, i, j);

  @override
  int get length => matrix.n;
}

class _EROOperatedColVector<T extends num> extends ColVector<T> {
  final Matrix<T> matrix;
  final ERO<T> ero;
  final int j;

  const _EROOperatedColVector(this.matrix, this.ero, this.j);

  @override
  T operator [](int i) => ero.getValue(matrix, i, j);

  @override
  int get length => matrix.m;
}

class _EROOperatedMatrix<T extends num> extends Matrix<T> {
  final Matrix<T> matrix;
  final ERO<T> ero;

  const _EROOperatedMatrix(this.matrix, this.ero);

  @override
  T getValue(int i, int j) => ero.getValue(matrix, i, j);

  @override
  RowVector<T> getRow(int i) => _EROOperatedRowVector(matrix, ero, i);

  @override
  ColVector<T> getCol(int j) => _EROOperatedColVector(matrix, ero, j);

  @override
  int get n => matrix.n;

  @override
  int get m => matrix.m;

  @override
  Iterator<Vector<T>> get iterator => rowIterator;

  @override
  int get length => matrix.m;
}
