part of '../vectors_and_matrices.dart';

class _FollowedByRowMatrix<T extends num> extends Matrix<T> {
  final Matrix<T> matrix;
  final RowVector<T> finalVector;

  const _FollowedByRowMatrix(this.matrix, this.finalVector);

  @override
  int get m => matrix.m + 1;

  @override
  int get n => matrix.n;

  @override
  RowVector<T> getRow(int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValidIndex(i, this, 'i');

    return i == matrix.m ? finalVector : matrix.getRow(i);
  }

  @override
  ColVector<T> getCol(int j) =>
      matrix.getCol(j).followedByValue(finalVector[j]);

  @override
  T getValue(int i, int j) {
    final row = getRow(i);
    return row[j];
  }

  @override
  int get length => matrix.m + 1;

  @override
  Iterator<Vector<T>> get iterator => rowIterator;
}
