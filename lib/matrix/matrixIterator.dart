part of '../vectors_and_matrices.dart';

class _RowIterator<T extends num> extends Iterator<RowVector<T>> with _IteratorMixin<RowVector<T>>{
  final Matrix<T> matrix;
  
  _RowIterator(this.matrix);

  @override
  int get length => matrix.m;

  @override
  RowVector<T> get value => matrix.getRow(i);
}

class _ColIterator<T extends num> extends Iterator<ColVector<T>> with _IteratorMixin<ColVector<T>>{
  final Matrix<T> matrix;
  
  _ColIterator(this.matrix);

  @override
  int get length => matrix.n;

  @override
  ColVector<T> get value => matrix.getCol(i);
}