part of '../vectors_and_matrices.dart';

class _TwoMatricesCombinedWRTRow<T extends num> extends Matrix<T>{
  final Matrix<T> firstMatrix;
  final Matrix<T> secondMatrix;

  const _TwoMatricesCombinedWRTRow(this.firstMatrix, this.secondMatrix);

  @override
  int get m => firstMatrix.m + secondMatrix.m;

  @override
  int get n => firstMatrix.n;

  @override
  int get length => firstMatrix.m + secondMatrix.m;

  @override
  Iterator<Vector<T>> get iterator => rowIterator;

  @override
  RowVector<T> getRow(int i){
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, m-1, 'i');

    return i < firstMatrix.m ? firstMatrix.getRow(i): secondMatrix.getRow(i - firstMatrix.m);
  }

  @override
  ColVector<T> getCol(int j){
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n-1, 'j');

    return firstMatrix.getCol(j).followedBy(secondMatrix.getCol(j));
  }

  @override
  T getValue(int i, int j){
    // find out which row we're in
    final row = getRow(i);
    // return the value on jth elt
    return row[j];
  }
}