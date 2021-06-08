part of '../vectors_and_matrices.dart';

/// A row span represents a [Span] of [RowVector].
class RowSpan extends Span<RowVector> {
  const RowSpan._(Set<RowVector> vectors, this.vectorLength) : super(vectors);

  /// Creates an empty span of row vectors.
  ///
  /// The [vectorLength] represents the length of the vectors.
  RowSpan.empty(this.vectorLength) : super({});

  /// Creates a span of row vectors.
  ///
  /// There must be at least one vector present. For an empty row span, use [RowSpan.empty].
  factory RowSpan(Iterable<RowVector> vectors) {
    if (vectors.isEmpty) throw StateError('There are no vectors in the set!');
    final length = vectors.first.length;
    for (final vector in vectors) {
      ArgumentError.checkNotNull(vector, 'vector');
      if (vector.length != length) {
        throw StateError('The length of all the vectors isn\'t the same!');
      }
    }
    return RowSpan._(vectors.toSet(), length);
  }

  /// Creates a span taking the row vectors of the matrix.
  factory RowSpan.fromMatrix(Matrix matrix) =>
      RowSpan._(matrix.toRowIterable().toSet(), matrix.n);

  @override
  final int vectorLength;

  @override
  bool get containsColVectors => true;

  @override
  Matrix get _matrixFromRowVectors => toMatrix();

  @override
  Matrix get _matrixFromColVectors =>
      Matrix.fromColVectors(map((vector) => vector.toColVector()).toList());

  @override
  Matrix _withRowBelow(Matrix matrix, RowVector vector) =>
      matrix.withRowBelow(vector);

  @override
  bool operator ==(RowSpan span) =>
      SetEquality().equals(_fromRREF, span._fromRREF);

  @override
  Matrix toMatrix() => Matrix.fromRowVectors(toList());

  @override
  RowSpan toOrthogonalSpan() =>
      RowSpan._(_matrixForOrthogonality.toSet(), length);

  @override
  RowSpan toOrthonormalSpan() => RowSpan._(
      _matrixForOrthogonality.map((vector) => vector.toUnitVector()).toSet(),
      length);

  @override
  RowSpan get complementSpan {
    final vectors =
        _orthogonalVectorsAsList.map((list) => RowVector.from(list));
    return RowSpan._(vectors.toSet(), vectorLength);
  }

  @override
  RowSpan intersection(RowSpan span) => RowSpan._(
      _calculateIntersectionVectors(span)
          .map((vector) => RowVector.from(vector))
          .toSet(),
      vectorLength);

  @override
  RowSpan toOrthogonalSpanByGramSchmidt() => RowSpan(_applyGramSchmidt());
}
