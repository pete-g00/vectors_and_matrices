part of '../vectors_and_matrices.dart';

class _PrecededByRowMatrix<T extends num> extends Matrix<T>{
  final Matrix<T> matrix;
  final RowVector<T> firstVector;

  const _PrecededByRowMatrix(this.matrix, this.firstVector);

  @override
  int get m => matrix.m+1;

  @override
  int get n => matrix.n;

  @override
  RowVector<T> getRow(int i){
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, matrix.m, 'i');

    return i == 1 ? firstVector : matrix.getRow(i-1);
  }

  @override
  ColVector<T> getCol(int j) => matrix.getCol(j).precededByValue(firstVector[j]);

  @override
  T getValue(int i, int j){
    final row = getRow(i);
    return row[j];
  }

  @override
  int get length => matrix.m+1;

  @override
  Iterator<Vector<T>> get iterator => rowIterator;
}