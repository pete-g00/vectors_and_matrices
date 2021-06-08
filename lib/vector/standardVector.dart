part of '../vectors_and_matrices.dart';

mixin _StandardVectorMixin<T extends num> on Vector<T> {
  List<T> get list;

  @override
  T operator [](int i) => list[i];

  @override
  int get length => list.length;
}

class _StandardRowVector<T extends num> extends RowVector<T>
    with _StandardVectorMixin<T> {
  const _StandardRowVector(this.list);

  @override
  final List<T> list;
}

class _StandardColVector<T extends num> extends ColVector<T>
    with _StandardVectorMixin<T> {
  const _StandardColVector(this.list);

  @override
  final List<T> list;
}
