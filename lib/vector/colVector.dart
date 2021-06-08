part of '../vectors_and_matrices.dart';

/// The class colVector represents a column [Vector].
abstract class ColVector<T extends num> extends Vector<T> {
  const ColVector();

  /// Creates a column vector from the provided list.
  const factory ColVector.from(List<T> list) = _StandardColVector;

  /// Creates a column vector that is made up of a single value.
  const factory ColVector.filled(int length, T value) = _FilledColVector;

  /// Generates a column vector of specific length using the provided function.
  const factory ColVector.generate(int length, T Function(int index) fn) =
      _GenerateColVector;

  /// Creates a column vector with a single non-zero value.
  ///
  /// We take in the `length` of the vector, and the value `i`, which is where the non-zero value is and the non-zero value.
  const factory ColVector.singleNonZero(int length, T value, int j) =
      _SingleNonZeroValuedColVector;

  @override
  bool get isColVector => true;

  @override
  ColVector<T> operator -(Vector<T> vector) => this + (-vector);

  @override
  ColVector<T> operator +(Vector<T> vector) {
    if (vector.isRowVector) {
      throw StateError('A column vector cannot be added to a row vector!');
    }
    if (length != vector.length) {
      throw StateError('The length of two vectors isn\'t the same!');
    }
    return _SummedColVector(this, vector);
  }

  @override
  ColVector<V> mapVector<V extends num>(V Function(T value, int i) fn) =>
      _MappedColVector(this, fn);

  @override
  ColVector<T> operator *(T scalar) => mapVector((value, i) => value * scalar);

  @override
  ColVector<T> operator -() => mapVector((value, i) => -value);

  @override
  ColVector<int> toIntVector() => mapVector((value, i) => value.toInt());

  @override
  ColVector<double> toDoubleVector() =>
      mapVector((value, i) => value.toDouble());

  @override
  int get hashCode => IterableEquality().hash(this);

  @override
  bool operator ==(covariant ColVector<num> vector) =>
      IterableEquality().equals(this, vector);

  @override
  ColVector<T> followedByValue(T lastValue) =>
      _FollowedByValueColVector(this, lastValue);

  @override
  ColVector<T> followedByVector(Vector<T> vector) {
    if (vector.isRowVector) {
      throw StateError('Cannot attach a row vector to a col vector!');
    }
    return _TwoVectorsAsOneColVector(this, vector);
  }

  @override
  ColVector<T> precededByValue(T firstValue) =>
      _PrecededByValueColVector(this, firstValue);

  @override
  ColVector<T> precededByVector(Vector<T> vector) {
    if (vector.isRowVector) {
      throw StateError('Cannot attach a row vector to a col vector!');
    }
    return _TwoVectorsAsOneColVector(vector, this);
  }

  @override
  ColVector<double> toUnitVector() =>
      magnitude == 0 ? null : _UnitColVector(this);

  @override
  ColVector<T> subVector(int start, [int end]) {
    end = RangeError.checkValidRange(start, end, length);
    return _SubColVector(this, start, end);
  }
}

class _VectorAsColVector<T extends num> extends ColVector<T>
    with _SurrogateVectorMixin<T> {
  @override
  final Vector<T> vector;

  const _VectorAsColVector(this.vector);
}
