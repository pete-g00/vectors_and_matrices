part of '../vectors_and_matrices.dart';

mixin _TwoVectorsAsOne<T extends num> on Vector<T> {
  Vector<T> get firstVector;

  Vector<T> get secondVector;

  @override
  int get length => firstVector.length + secondVector.length;

  @override
  T operator [](int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValidIndex(i, this, 'i');

    return i < firstVector.length
        ? firstVector[i]
        : secondVector[i - firstVector.length];
  }
}

class _TwoVectorsAsOneRowVector<T extends num> extends RowVector<T>
    with _TwoVectorsAsOne<T> {
  @override
  final RowVector<T> firstVector;

  @override
  final RowVector<T> secondVector;

  const _TwoVectorsAsOneRowVector(this.firstVector, this.secondVector);
}

class _TwoVectorsAsOneColVector<T extends num> extends ColVector<T>
    with _TwoVectorsAsOne<T> {
  @override
  final ColVector<T> firstVector;

  @override
  final ColVector<T> secondVector;

  const _TwoVectorsAsOneColVector(this.firstVector, this.secondVector);
}
