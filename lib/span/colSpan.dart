part of '../vectors_and_matrices.dart';

/// A column span represents a [Span] of [ColVector].
class ColSpan extends Span<ColVector> {
  const ColSpan._(Set<ColVector> vectors, this.vectorLength) : super(vectors);

  /// Creates an empty span of column vectors.
  ///
  /// The [vectorLength] represents the length of the vectors.
  ColSpan.empty(this.vectorLength) : super({});

  /// Creates a span of column vectors.
  factory ColSpan(Iterable<ColVector> vectors) {
    if (vectors.isEmpty) throw StateError('There are no vectors in the set!');
    final length = vectors.first.length;
    for (final vector in vectors) {
      ArgumentError.checkNotNull(vector, 'vector');
      if (vector.length != length) {
        throw StateError('The length of all the vectors isn\'t the same!');
      }
    }
    return ColSpan._(vectors.toSet(), length);
  }

  /// Creates a span taking the column vectors of the matrix.
  factory ColSpan.fromMatrix(Matrix matrix) =>
      ColSpan._(matrix.toColIterable().toSet(), matrix.m);

  @override
  final int vectorLength;

  @override
  bool get containsColVectors => true;

  @override
  Matrix get _matrixFromRowVectors =>
      Matrix.fromRowVectors(map((vector) => vector.toRowVector()).toList());

  @override
  Matrix get _matrixFromColVectors => toMatrix();

  @override
  Matrix _withRowBelow(Matrix matrix, ColVector vector) =>
      matrix.withRowBelow(vector.toRowVector());

  @override
  bool operator ==(ColSpan span) =>
      SetEquality().equals(_fromRREF, span._fromRREF);

  @override
  Matrix toMatrix() => Matrix.fromColVectors(toList());

  @override
  ColSpan toOrthogonalSpan() => ColSpan._(
      _matrixForOrthogonality.map((vector) => vector.toColVector()).toSet(),
      length);

  @override
  ColSpan toOrthonormalSpan() => ColSpan._(
      _matrixForOrthogonality
          .map((vector) => vector.toColVector().toUnitVector())
          .toSet(),
      length);

  @override
  ColSpan get complementSpan {
    final vectors =
        _orthogonalVectorsAsList.map((list) => ColVector.from(list));
    return ColSpan._(vectors.toSet(), vectorLength);
  }

  @override
  ColSpan intersection(ColSpan span) => ColSpan._(
      _calculateIntersectionVectors(span)
          .map((vector) => ColVector.from(vector))
          .toSet(),
      vectorLength);

  @override
  ColSpan toOrthogonalSpanByGramSchmidt() => ColSpan(_applyGramSchmidt());
}
