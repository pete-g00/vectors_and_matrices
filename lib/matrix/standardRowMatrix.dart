part of '../vectors_and_matrices.dart';

class _StandardRowMatrixColVector<T extends num> extends ColVector<T>{
  const _StandardRowMatrixColVector(this.value, this.j);

  final List<List<T>> value;
  final int j;

  @override
  T operator [](int i) =>  value[i][j];

  @override
  int get length => value.length;
}

mixin _StandardRowMatrixMixin<T extends num> on Matrix<T>{
  List<List<T>> get value;

   @override
  T getValue(int i, int j) => value[i][j];

  @override
  ColVector<T> getCol(int j) {
    RangeError.checkValueInInterval(j, 0, value.first.length-1, 'j');

    return _StandardRowMatrixColVector(value, j);
  }

  @override
  RowVector<T> getRow(int i) => RowVector.from(value[i]);

  @override
  Iterator<Vector<T>> get iterator => rowIterator; 
}

class _StandardRowMatrix<T extends num> extends Matrix<T> with _StandardRowMatrixMixin<T>{
  @override
  final List<List<T>> value;

  const _StandardRowMatrix(this.value);

  @override
  int get m => value.length;

  @override
  int get n => value.first.length;

  @override
  int get length => value.length;
}

class _StandardSquareRowMatrix<T extends num> extends SquareMatrix<T> with _StandardRowMatrixMixin<T>{
  @override
  final List<List<T>> value;

  const _StandardSquareRowMatrix(this.value);

  @override
  int get n => value.length;
}
