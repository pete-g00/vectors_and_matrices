part of '../vectors_and_matrices.dart';

T _multipliedMatrixGetValue<T extends num>(Matrix<T> matrix1, Matrix<T> matrix2, int i, int j){
  final row = matrix1.getRow(i);
  final col = matrix2.getCol(j);
  return row.dotProduct(col);
}

class _MultipliedMatrixCol<T extends num> extends ColVector<T>{
  final Matrix<T> matrix1;
  final Matrix<T> matrix2;
  final int j;

  const _MultipliedMatrixCol(this.matrix1, this.matrix2, this.j);

  @override
  T operator[](int i) => _multipliedMatrixGetValue(matrix1, matrix2, i, j);

  @override
  int get length => matrix1.m;
}

class _MultipliedMatrixRow<T extends num> extends RowVector<T>{
  final Matrix<T> matrix1;
  final Matrix<T> matrix2;
  final int i;

  const _MultipliedMatrixRow(this.matrix1, this.matrix2, this.i);

  @override
  T operator[](int j) => _multipliedMatrixGetValue(matrix1, matrix2, i, j);

  @override
  int get length => matrix2.n;
}

class _MultipliedMatrix<T extends num> extends Matrix<T>{
  final Matrix<T> matrix1;
  final Matrix<T> matrix2;

  const _MultipliedMatrix(this.matrix1, this.matrix2);

  @override
  int get m => matrix1.m;

  @override
  int get n => matrix2.n;

  @override
  T getValue(int i, int j) => _multipliedMatrixGetValue(matrix1, matrix2, i, j);

  @override
  ColVector<T> getCol(int j) {
    ArgumentError.checkNotNull(j, 'j');
    RangeError.checkValueInInterval(j, 0, n-1, 'j');

    return _MultipliedMatrixCol(matrix1, matrix2, j);
  }

  @override
  RowVector<T> getRow(int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, m-1, 'i');
    
    return _MultipliedMatrixRow(matrix1, matrix2, i);
  }

  @override
  int get length => matrix1.m;

  @override
  Iterator<Vector<T>> get iterator => rowIterator;
}
