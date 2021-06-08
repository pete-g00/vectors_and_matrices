# Vectors and matrices

This package implements three linear algebra classes `Vector`, `Matrix` and `Span`. 

It also defines many properties to them such as `Vector.magnitude`, `Matrix.rank` and `Span.complementSpan`.

## Getting Started

To import this package, include the following code:

``` dart
import 'package:vectors_and_matrices/vectors_and_matrices.dart';
```

## The class Vector

The class `Vector` (as `RowVector` and `ColVector`) is an iterable collection of `num` (`int` or `double`). The following are few of its properties in use:

``` dart
const vector1 = RowVector.from([0, -1, 3]);
const vector2 = RowVector.filled(3, 1);
print(vector2); // Vector([1, 1, 1])
print(vector1  * 2 - vector2);  // Vector([-1, -3, 5])
print(vector1.dotProduct(vector2)); // 2
print(vector1.isOrthogonalTo(vector2)); // false
print(vector1.firstNonZeroIndex()); // 1
print(vector2.firstNonZeroIndex()); // 0
```

Every calculation that returns a vector creates a lazy iterable.

## The class Span

The class `Span` (concerte implementations `RowSpan` and `ColSpan`) extends a `Set` of `Vector`. The following are few of its properties in use:

``` dart
final span1 = ColSpan([
  // [0, 3, 6, 9]
  ColVector.generate(4, (i) => 3*i),
  ColVector.from([0, 2, 4, 6]),
  ColVector.from([-1, 0, 2, 0]),
]);
final span2 = ColSpan([
  ColVector.from([3, 5, 1, -1]),
  ColVector.from([3, 6, 3, 2])
]);
print(span2.isLinearlyIndependent); // true
print(span1.dimension); // 2
print(span2.contains(ColVector.from([1, 1, 1, -2]))); // true
print(span1.intersection(span2)); // Span([0.0, 1.0, 2.0, 3.0])
```

It inherits many properties from a set, but some of them are overriden, like `operator ==`, `contains` and `intersection`, which get computed to reflect the mathematical definition of a span.

## The class Matrix

The class `Matrix` is an iterable collection of `Vector`. It can be iterated through the columns (as `ColVector`) or the rows (as `RowVector`). The following are a few of its properties:

``` dart
final matrix1 = Matrix.fromRows([
  [1, 0, 1, 3],
  [2, -1, 0, 1],
  [0, 1, 1, 0],
]);
final matrix2 = Matrix.fromRows([
  [5, 0, 0, 1],
  [-1, 1, 0, -1],
  [-3, 0, 0, 0],
]);
print(matrix1 + matrix2.scalarMultiply(-3)); // Matrix([-14, 0, 1, 0], [5, -4, 0, 4], [9, 1, 1, 0])
print(matrix1.toREF()); // Matrix([1, 0, 1, 3], [0, -1, -2, -5], [0, 0, 1, 5])
print(matrix1.toRREF()); // Matrix([1.0, 0.0, 0.0, -2.0], [0.0, 1.0, 0.0, -5.0], [0.0, 0.0, 1.0, 5.0])
print(matrix1.rank); // 3
print(matrix1.nullSpace); // Span([2.0, 5.0, -5.0, 1.0])
```

We represent square matrices with the class `SquareMatrix`, where the length of the rows and the columns is the same. It has further properties, like the ones in the example below:

``` dart
final sqMatrix1 = SquareMatrix.diagonal([3, 1, 0]);
final sqMatrix2 = SquareMatrix.fromRows([
  [0, 2, 0],
  [1, 0, -2],
  [-1, 1, 0]
]);
print(sqMatrix1 * sqMatrix2); // Matrix([0, 6, 0], [1, 0, -2], [0, 0, 0])
print(sqMatrix2.determinant); // 4
print(sqMatrix1 ^ 3); // Matrix([27.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 0.0])
print(sqMatrix2.invert()); // Matrix([0.5, 0.0, -1.0], [0.5, 0.0, 0.0], [0.25, -0.5, -0.5])
print(sqMatrix1.eigenspaceFor(0)); // Span([0.0, 0.0, 1.0])
```

## The class ERO

It is also possible to operate an `ERO` (elementary row operation) on a matrix, like:

``` dart
final ero = ERO<int>.swap(0, 1);
final matrix = SquareMatrix.identity(3);
print(matrix.operateERO(ero)); // Matrix([[0, 1, 0], [1, 0, 0], [0, 0, 1]])
```

There are 3 types of EROs, `ERO.swap`, `ERO.sum` and `ERO.scale`, each of which can be operated to a matrix.