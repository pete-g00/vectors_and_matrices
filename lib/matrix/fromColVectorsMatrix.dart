part of '../vectors_and_matrices.dart';

class _FromColVectorsMatrixRowVector<T extends num> extends RowVector<T> {
  const _FromColVectorsMatrixRowVector(this.value, this.i);

  final List<ColVector<T>> value;
  final int i;

  @override
  T operator [](int j) => value[j][i];

  @override
  int get length => value.length;
}

mixin _FromColVectorsMatrixMixin<T extends num> on Matrix<T> {
  List<ColVector<T>> get value;

  @override
  RowVector<T> getRow(int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValueInInterval(i, 0, m - 1);

    return _FromColVectorsMatrixRowVector(value, i);
  }

  @override
  ColVector<T> getCol(int j) => value[j];

  @override
  T getValue(int i, int j) => value[j][i];

  @override
  Iterator<Vector<T>> get iterator => value.iterator;
}

class _FromColVectorsMatrix<T extends num> extends Matrix<T>
    with _FromColVectorsMatrixMixin<T> {
  const _FromColVectorsMatrix(this.value);

  @override
  final List<ColVector<T>> value;

  @override
  int get m => value.first.length;

  @override
  int get n => value.length;

  @override
  int get length => value.length;
}

class _FromColVectorsSquareMatrix<T extends num> extends SquareMatrix<T>
    with _FromColVectorsMatrixMixin<T> {
  const _FromColVectorsSquareMatrix(this.value);

  @override
  final List<ColVector<T>> value;

  @override
  int get n => value.length;
}
