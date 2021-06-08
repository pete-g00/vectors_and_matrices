part of '../vectors_and_matrices.dart';

/// The class rowVector represents a row [Vector].
abstract class RowVector<T extends num> extends Vector<T> {
  const RowVector();

  /// Creates a row vector from the provided list.
  const factory RowVector.from(List<T> list) = _StandardRowVector;

  /// Creates a row vector that is made up of a single value.
  const factory RowVector.filled(int length, T value) = _FilledRowVector;

  /// Generates a row vector of specific length using the provided function.
  const factory RowVector.generate(int length, T Function(int index) fn) =
      _GenerateRowVector;

  /// Creates a row vector with a single non-zero value.
  ///
  /// We take in the `length` of the vector, and the value `i`, which is where the non-zero value is and the non-zero value.
  const factory RowVector.singleNonZero(int length, T value, int i) =
      _SingleNonZeroValuedRowVector;

  @override
  bool get isColVector => false;

  @override
  RowVector<T> operator -(Vector<T> vector) => this + (-vector);

  @override
  RowVector<T> operator +(Vector<T> vector) {
    if (vector.isColVector) {
      throw StateError('A row vector cannot be added to a column vector!');
    }
    if (length != vector.length) {
      throw StateError('The length of two vectors isn\'t the same!');
    }
    return _SummedRowVector(this, vector);
  }

  @override
  RowVector<V> mapVector<V extends num>(V Function(T value, int i) fn) =>
      _MappedRowVector(this, fn);

  @override
  RowVector<T> operator *(T scalar) => mapVector((value, i) => value * scalar);

  @override
  RowVector<T> operator -() => mapVector((value, i) => -value);

  @override
  RowVector<int> toIntVector() => mapVector((value, i) => value.toInt());

  @override
  RowVector<double> toDoubleVector() =>
      mapVector((value, i) => value.toDouble());

  @override
  int get hashCode => IterableEquality().hash(this);

  @override
  bool operator ==(covariant RowVector<num> vector) =>
      IterableEquality().equals(this, vector);

  @override
  RowVector<T> followedByValue(T nextValue) =>
      _FollowedByValueRowVector(this, nextValue);

  @override
  RowVector<T> followedByVector(Vector<T> vector) {
    if (vector.isColVector) {
      throw StateError('Cannot attach a col vector to a row vector!');
    }
    return _TwoVectorsAsOneRowVector(this, vector);
  }

  @override
  RowVector<T> precededByValue(T firstValue) =>
      _PrecededByValueRowVector(this, firstValue);

  @override
  RowVector<T> precededByVector(Vector<T> vector) {
    if (vector.isColVector) {
      throw StateError('Cannot attach a col vector to a row vector!');
    }
    return _TwoVectorsAsOneRowVector(vector, this);
  }

  @override
  RowVector<double> toUnitVector() =>
      magnitude == 0 ? null : _UnitRowVector(this);

  @override
  RowVector<T> subVector(int start, [int end]) {
    end = RangeError.checkValidRange(start, end, length);
    return _SubRowVector(this, start, end);
  }
}

class _VectorAsRowVector<T extends num> extends RowVector<T>
    with _SurrogateVectorMixin<T> {
  @override
  final Vector<T> vector;

  const _VectorAsRowVector(this.vector);
}
