part of '../vectors_and_matrices.dart';

class _FollowedByColMatrix<T extends num> extends Matrix<T> {
  final Matrix<T> matrix;
  final ColVector<T> rightVector;

  const _FollowedByColMatrix(this.matrix, this.rightVector);

  @override
  int get m => matrix.m;

  @override
  int get n => matrix.n + 1;

  @override
  RowVector<T> getRow(int i) =>
      matrix.getRow(i).followedByValue(rightVector[i]);

  @override
  ColVector<T> getCol(int j) {
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, matrix.n, 'j');

    return j == matrix.n ? rightVector : matrix.getCol(j);
  }

  @override
  T getValue(int i, int j) {
    final row = getCol(j);
    return row[i];
  }

  @override
  int get length => matrix.n + 1;

  @override
  Iterator<Vector<T>> get iterator => colIterator;
}
