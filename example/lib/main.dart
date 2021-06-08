import 'package:vectors_and_matrices/vectors_and_matrices.dart';

void main(List<String> args) {
  // vector
  final vector1 = RowVector.from([0, -1, 3]);
  final vector2 = RowVector.filled(3, 1);
  print(vector2); // Vector([1, 1, 1])
  print(vector1  * 2 - vector2);  // Vector([-1, -3, 5])
  print(vector1.dotProduct(vector2)); // 2
  print(vector1.isOrthogonalTo(vector2)); // false
  print(vector1.firstNonZeroIndex()); // 1
  print(vector2.firstNonZeroIndex()); // 0
  print(vector1.isMultipleOf(vector2)); // false

  // span
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
  print(span2.contains(ColVector.from([-3, -4, 1, 4]))); // true
  print(span1.intersection(span2)); // Span([0.0, 1.0, 2.0, 3.0])
  
  // matrix
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

  // square matrix
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

  // ero
  final ero = ERO<int>.swap(0, 1);
  final matrix = SquareMatrix.identity(3);
  print(matrix.operateERO(ero)); // Matrix([[0, 1, 0], [1, 0, 0], [0, 0, 1]])
}
