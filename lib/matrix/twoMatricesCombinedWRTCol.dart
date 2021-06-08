part of '../vectors_and_matrices.dart';

class _TwoMatricesCombinedWRTColMatrix<T extends num> extends Matrix<T>{
  final Matrix<T> leftMatrix;
  final Matrix<T> rightMatrix;

  const _TwoMatricesCombinedWRTColMatrix(this.leftMatrix, this.rightMatrix);

  @override
  int get m => leftMatrix.m;

  @override
  int get n => leftMatrix.n + rightMatrix.n;

  @override
  RowVector<T> getRow(int i){
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, m-1, 'i');

    return leftMatrix.getRow(i).followedByVector(rightMatrix.getRow(i));
  }

  @override
  ColVector<T> getCol(int j){
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n-1, 'j');

    return j < leftMatrix.n ? leftMatrix.getCol(j): rightMatrix.getCol(j - leftMatrix.n);
  }

  @override
  T getValue(int i, int j){
    final col = getCol(j);
    return col[i];
  }

  @override
  int get length => leftMatrix.n + rightMatrix.n;

  @override
  Iterator<Vector<T>> get iterator => colIterator;
}