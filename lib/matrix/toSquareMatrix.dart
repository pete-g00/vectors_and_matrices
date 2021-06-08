part of '../vectors_and_matrices.dart';

class _ToSquareMatrix<T extends num> extends SquareMatrix<T>{
  final Matrix<T> matrix;

  const _ToSquareMatrix(this.matrix);

  @override
  int get n => matrix.length;

  @override
  Iterator<Vector<T>> get iterator => matrix.iterator;

  @override
  RowVector<T> getRow(int i) => matrix.getRow(i);

  @override
  ColVector<T> getCol(int j) => matrix.getCol(j);

  @override
  T getValue(int i, int j) => matrix.getValue(i, j);
}