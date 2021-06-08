part of '../vectors_and_matrices.dart';

mixin _MappedVectorMixin<T extends num, V extends num> on Vector<V> {
  Vector<T> get vector;

  V Function(T value, int i) get fn;

  @override
  V operator [](int i) => fn(vector[i], i);

  @override
  int get length => vector.length;
}

class _MappedRowVector<T extends num, V extends num> extends RowVector<V>
    with _MappedVectorMixin<T, V> {
  @override
  final Vector<T> vector;

  @override
  final V Function(T value, int i) fn;

  const _MappedRowVector(this.vector, this.fn);
}

class _MappedColVector<T extends num, V extends num> extends ColVector<V>
    with _MappedVectorMixin<T, V> {
  @override
  final Vector<T> vector;

  @override
  final V Function(T value, int i) fn;

  const _MappedColVector(this.vector, this.fn);
}
