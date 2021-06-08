part of '../vectors_and_matrices.dart';

class _FromRowVectorsMatrixColVector<T extends num> extends ColVector<T> {
  const _FromRowVectorsMatrixColVector(this.value, this.j);

  final List<RowVector<T>> value;
  final int j;

  @override
  int get length => value.length;

  @override
  T operator [](int i) => value[i][j];
}

mixin _FromRowVectorsMatrixMixin<T extends num> on Matrix<T> {
  List<RowVector<T>> get value;

  @override
  RowVector<T> getRow(int i) => value[i];

  @override
  ColVector<T> getCol(int j) => _FromRowVectorsMatrixColVector(value, j);

  @override
  T getValue(int i, int j) => value[i][j];

  @override
  Iterator<Vector<T>> get iterator => value.iterator;
}

class _FromRowVectorsMatrix<T extends num> extends Matrix<T>
    with _FromRowVectorsMatrixMixin<T> {
  @override
  final List<RowVector<T>> value;

  const _FromRowVectorsMatrix(this.value);

  @override
  int get m => value.length;

  @override
  int get n => value.first.length;

  @override
  int get length => value.length;
}

class _FromRowVectorsSquareMatrix<T extends num> extends SquareMatrix<T>
    with _FromRowVectorsMatrixMixin<T> {
  @override
  final List<RowVector<T>> value;

  const _FromRowVectorsSquareMatrix(this.value);

  @override
  int get n => value.length;
}
