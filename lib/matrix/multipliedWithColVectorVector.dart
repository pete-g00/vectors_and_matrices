part of '../vectors_and_matrices.dart';

class _MultipliedWithColVector<T extends num> extends ColVector<T>{
  final Matrix<T> matrix;
  final ColVector<T> vector;
  
  const _MultipliedWithColVector(this.matrix, this.vector);

  @override
  int get length => matrix.m;

  @override
  T operator [](int i){
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, matrix.m - 1, 'i');
    
    final row = matrix.getRow(i);
    return row.dotProduct(vector);
  }
}
