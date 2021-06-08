part of '../vectors_and_matrices.dart';

class _SumMatrix<T extends num> extends Matrix<T>{
  final Matrix<T> matrix1;
  final Matrix<T> matrix2;

  const _SumMatrix(this.matrix1, this.matrix2);

  @override
  Iterator<Vector<T>> get iterator => rowIterator;

  @override
  ColVector<T> getCol(int j) => (matrix1.getCol(j) + matrix2.getCol(j)).toColVector();

  @override
  RowVector<T> getRow(int i) => (matrix1.getRow(i) + matrix2.getRow(i)).toRowVector();

  @override
  T getValue(int i, int j) => matrix1.getValue(i, j) + matrix2.getValue(i, j);

  @override
  int get m => matrix1.m;

  @override
  int get n => matrix2.n;
}
