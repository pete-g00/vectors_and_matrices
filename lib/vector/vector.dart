part of '../vectors_and_matrices.dart';

/// The class vector represents an iterable collection of `int` or `double`.
///
/// They are list-like collections for which we expect the following properties to be overriden in any concerte class:
///
/// * the [operator []], which returns the element at an index within the iterable.
///
/// * the [length] getter, which returns the length of the vector efficiently.
///
/// Every vector created is either a [RowVector] or a [ColVector]. It isn't typically possible for a row vector to operate on a column vector.
/// The only exception to this is when calculating the [dotProduct].
///
/// This also implies that many of our concrete implementation of properties such as [mapVector], [operator -] happen at [RowVector] and [ColVector],
/// not at vector. This ensures that row vectors stay row vectors and col vectors stay col vectors following modification.
///
/// The equality operation [operator ==] has been modified for a vector such that 2 vectors are equal if and only if:
///
/// * they are of same length and have the same elements in the same order.
///
/// * they are both row/col vectors.
///
/// Most properties of a vector are represented as [RowVector] or [ColVector] as part of closure.
abstract class Vector<T extends num> extends Iterable<T> {
  const Vector();

  @override
  String toString() =>
      'Vector(${IterableBase.iterableToShortString(this, '[', ']')})';

  /// Returns the element at the `i`-th index in the vector.
  T operator [](int i);

  /// Returns `true` if the vector is a column vector.
  bool get isColVector;

  /// Returns `true` if the vector is a row vector.
  bool get isRowVector => !isColVector;

  /// Returns the first non-zero index in the vector.
  ///
  /// Returns `null` if the vector only has zero values.
  ///
  /// A start index can be provided to indicate where to start from.
  int firstNonZeroIndex([int startIndex = 0]) {
    if (startIndex < 0) startIndex = 0;
    for (var i = startIndex; i < length; i++) {
      if (this[i] != 0) return i;
    }
    return null;
  }

  /// Returns the first non-zero value in the vector.
  ///
  /// Returns `null` if the vector only has zero values.
  ///
  /// A start index can be provided to indicate where to start from.
  T firstNonZeroValue([int startIndex = 0]) {
    final i = firstNonZeroIndex(startIndex);
    return i.isNull ? null : this[i];
  }

  /// Returns `true` if the vector is a zero vector.
  bool get isZeroVector => firstNonZeroIndex().isNull;

  /// Returns `true` if the vector isn't a zero vector.
  bool get isNotZeroVector => !isZeroVector;

  /// Returns the last non-zero index in the vector.
  ///
  /// Returns `null` if the vector only has zero values.
  ///
  /// A start index can be provided to indicate where to start from.
  int lastNonZeroIndex([int startIndex]) {
    startIndex ??= length - 1;
    if (startIndex > length - 1) startIndex = length - 1;
    for (var i = startIndex; i > -1; i--) {
      if (this[i] != 0) return i;
    }
    return null;
  }

  /// Returns the last non-zero value in the vector.
  ///
  /// Returns `null` if the vector only has zero values.
  ///
  /// A start index can be provided to indicate where to start from.
  T lastNonZeroValue([int startIndex]) {
    final i = lastNonZeroIndex(startIndex);
    return i.isNull ? null : this[i];
  }

  /// Makes the vector a row vector.
  RowVector<T> toRowVector() => _VectorAsRowVector(this);

  /// Makes the vector a column vector.
  ColVector<T> toColVector() => _VectorAsColVector(this);

  @override
  Iterator<T> get iterator => _VectorIterator(this);

  /// Returns the vector as with integer components.
  Vector<int> toIntVector();

  /// Returns the vector as with double components.
  Vector<double> toDoubleVector();

  /// Maps a vector into another vector by applying `fn` to each the value.
  ///
  /// In the function, we are provided by the `value` at an index, along with the index `i`.
  Vector<V> mapVector<V extends num>(V Function(T value, int i) fn);

  /// Returns a new vector which is made up of the elements from this vector along with the provided `lastValue` at the end.
  Vector<T> followedByValue(T lastValue);

  /// Returns a new vector which is made up of this vector along with the provided vector after this vector.
  Vector<T> followedByVector(Vector<T> vector);

  /// Returns a new vector which is made up of the elements from this vector along with the provided `firstValue` at the start.
  Vector<T> precededByValue(T firstValue);

  /// Returns a new vector which is made up of this vector along with the provided vector before this vector.
  Vector<T> precededByVector(Vector<T> vector);

  /// Returns the magnitude of the vector.
  double get magnitude => sqrt(fold<double>(
      0, (previousValue, element) => previousValue + element * element));

  /// Returns the dot product of `this` with the provided vector.
  ///
  /// They must have the same length.
  T dotProduct(Vector<T> vector) {
    if (vector.length != length) {
      throw StateError('The length of the two vectors is different!');
    }
    var product = _intAsT(0);
    for (var i = 0; i < length; i++) {
      product += this[i] * vector[i];
    }
    return product;
  }

  /// Returns `true` if the two vectors are orthogonal to each other.
  bool isOrthogonalTo(Vector<T> vector) => dotProduct(vector) == 0;

  /// Returns `true` if this vector is a multiple of the vector provided.
  bool isMultipleOf<V extends num>(Vector<V> vector) {
    if (length != vector.length) return false;
    var value = double.nan;
    var thisIsZero = true;
    for (var i = 0; i < length; i++) {
      if (this[i] != 0){
        thisIsZero = false;
      }
      final ratio = this[i] / vector[i];
      if (value.isNaN) {
        value = ratio;
      } else if (!ratio.isNaN && value != ratio) {
        return false;
      }
    }
    // if this vector is zero, return false
    if (thisIsZero){
      return false;
    }
    return true;
  }

  /// Subtracts this vector with another vector componentwise.
  Vector<T> operator -(Vector<T> vector);
  //  => this + (-vector);

  /// Adds this vector with another vector componentwise.
  Vector<T> operator +(Vector<T> vector);

  /// Multiplies all the elements within the vector with another scalar.
  Vector<T> operator *(T scalar);

  /// Inverts the sign of all the components within this vector.
  Vector<T> operator -();

  /// Projects this vector onto the provided `vector`.
  Vector<double> projectOnto(Vector<T> vector) =>
      vector.toDoubleVector() *
      (dotProduct(vector) / vector.dotProduct(vector));

  /// Returns this vector as a unit vector.
  ///
  /// If the vector has magnitude 0, returns `null`.
  Vector<double> toUnitVector();

  /// Returns a subvector of this vector.
  ///
  /// The subvector starts from the `start` (inclusive) and ends at the `end` (exclusive).
  /// If the `endIndex` isn't provided, the subvector continues till the end of the list.
  Vector<T> subVector(int start, [int end]);

  T _intAsT(int i) {
    switch (T) {
      case int:
        return i as T;
      case double:
        return i.toDouble() as T;
      case num:
        return i as T;
      default:
        throw null;
    }
  }
}

class _VectorIterator<T extends num> extends Iterator<T>
    with _IteratorMixin<T> {
  final Vector<T> vector;

  _VectorIterator(this.vector);

  @override
  int get length => vector.length;

  @override
  T get value => vector[i];
}

mixin _SurrogateVectorMixin<T extends num> on Vector<T> {
  Vector<T> get vector;

  @override
  T operator [](int i) => vector[i];

  @override
  int get length => vector.length;
}
