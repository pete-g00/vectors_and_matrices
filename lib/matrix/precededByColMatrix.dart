part of '../vectors_and_matrices.dart';

class _PrecededByColMatrix<T extends num> extends Matrix<T>{
  final Matrix<T> matrix;
  final ColVector<T> leftVector;

  const _PrecededByColMatrix(this.matrix, this.leftVector);

  @override
  int get m => matrix.m;

  @override
  int get n => matrix.n+1;

  @override
  RowVector<T> getRow(int i) => matrix.getRow(i).precededByValue(leftVector[i]);

  @override
  ColVector<T> getCol(int j){
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, matrix.n, 'j');

    return j == 0 ? leftVector : matrix.getCol(j-1);
  }

  @override
  T getValue(int i, int j){
    final row = getCol(j);
    return row[i];
  }

  @override
  int get length => matrix.n+1;

  @override
  Iterator<Vector<T>> get iterator => colIterator;
}