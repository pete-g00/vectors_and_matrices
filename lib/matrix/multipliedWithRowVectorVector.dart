part of '../vectors_and_matrices.dart';

class _MultipliedWithRowVector<T extends num> extends RowVector<T>{
  final Matrix<T> matrix;
  final RowVector<T> vector;
  
  const _MultipliedWithRowVector(this.matrix, this.vector);

  @override
  int get length => matrix.n;

  @override
  T operator [](int j){
    ArgumentError.checkNotNull(j, 'i');
    RangeError.checkValueInInterval(j, 0, matrix.m - 1, 'i');

    final row = matrix.getCol(j);
    return row.dotProduct(vector);
  }
}
