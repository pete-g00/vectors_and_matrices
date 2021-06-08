part of '../vectors_and_matrices.dart';

class _TransposedMatrix<T extends num> extends Matrix<T>{
  final Matrix<T> matrix;

  const _TransposedMatrix(this.matrix);

  @override
  ColVector<T> getCol(int j) => matrix.getRow(j).toColVector();

  @override
  RowVector<T> getRow(int i) => matrix.getCol(i).toRowVector();

  @override
  T getValue(int i, int j) => matrix.getValue(j, i);

  @override
  int get m => matrix.n;

  @override
  int get n => matrix.m;
  
  @override
  Iterator<Vector<T>> get iterator => colIterator;
}
