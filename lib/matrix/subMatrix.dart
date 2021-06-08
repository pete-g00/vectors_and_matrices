part of '../vectors_and_matrices.dart';

class _SubMatrix<T extends num> extends Matrix<T>{
  final Matrix<T> matrix;
  final int i1;
  final int i2;
  final int j1;
  final int j2;

  const _SubMatrix(this.matrix, this.i1, this.i2, this.j1, this.j2);

  @override
  int get m => i2 - i1;

  @override
  int get n => j2 - j1;

  @override
  RowVector<T> getRow(int i){
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, m-1);

    return matrix.getRow(i + i1).subVector(j1, j2);
  }

  @override
  ColVector<T> getCol(int j){
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n-1);

    return matrix.getCol(j + j1).subVector(i1, i2);
  }

  @override
  T getValue(int i, int j){
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, m-1, 'i');
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n-1, 'j');

    return matrix.getValue(i + i1, j + j1);
  }

  @override
  int get length => i2 - i1;

  @override
  Iterator<Vector<T>> get iterator => rowIterator;
}