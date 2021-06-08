part of '../vectors_and_matrices.dart';

mixin _FollowedByValueMixin<T extends num> on Vector<T> {
  Vector<T> get vector;
  T get nextValue;

  @override
  int get length => vector.length + 1;

  @override
  T operator [](int i) {
    ArgumentError.checkNotNull(i, 'i');
    RangeError.checkValidIndex(i, this, 'i');

    return i == vector.length ? nextValue : vector[i];
  }
}

class _FollowedByValueRowVector<T extends num> extends RowVector<T>
    with _FollowedByValueMixin<T> {
  @override
  final Vector<T> vector;

  @override
  final T nextValue;

  const _FollowedByValueRowVector(this.vector, this.nextValue);
}

class _FollowedByValueColVector<T extends num> extends ColVector<T>
    with _FollowedByValueMixin<T> {
  @override
  final Vector<T> vector;

  @override
  final T nextValue;

  const _FollowedByValueColVector(this.vector, this.nextValue);
}
