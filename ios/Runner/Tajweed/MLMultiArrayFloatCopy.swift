import CoreML
import Foundation

/// Fast float32 paths for CoreML `MLMultiArray` I/O.
/// Avoids per-element `NSNumber` boxing (`array[i] = NSNumber(...)` / `.floatValue`),
/// which dominated `coremlInputCopyMs` / `coremlOutputParseMs` without changing values.
enum MLMultiArrayFloatCopy {
  /// Copy a contiguous Swift float buffer into a float32 multi-array (same element order).
  static func copy(_ source: [Float], into array: MLMultiArray) {
    let count = source.count
    guard count > 0 else { return }
    if array.dataType == .float32, isContiguousFloat32(array, elementCount: count) {
      let dst = array.dataPointer.bindMemory(to: Float.self, capacity: count)
      source.withUnsafeBufferPointer { src in
        guard let base = src.baseAddress else { return }
        dst.update(from: base, count: count)
      }
      return
    }
    for i in 0..<count {
      array[i] = NSNumber(value: source[i])
    }
  }

  /// Copy float32 multi-array into row-major `[[Float]]` with shape `[rows][cols]`.
  /// Element order matches the previous `array[t * cols + v].floatValue` loop when contiguous.
  static func copyRows(from array: MLMultiArray, rows: Int, cols: Int) -> [[Float]] {
    guard rows > 0, cols > 0 else { return [] }
    let count = rows * cols
    var flat = [Float](repeating: 0, count: count)
    if array.dataType == .float32, isContiguousFloat32(array, elementCount: count) {
      let src = array.dataPointer.bindMemory(to: Float.self, capacity: count)
      flat.withUnsafeMutableBufferPointer { dst in
        guard let base = dst.baseAddress else { return }
        base.update(from: src, count: count)
      }
    } else if array.dataType == .float32 {
      let ptr = array.dataPointer.bindMemory(to: Float.self, capacity: max(1, array.count))
      let strides = array.strides.map(\.intValue)
      let shape = array.shape.map(\.intValue)
      // Support [1, rows, cols] or [rows, cols] float32 with arbitrary strides.
      if shape.count >= 2 {
        let rowStride: Int
        let colStride: Int
        if shape.count >= 3 {
          rowStride = strides[shape.count - 2]
          colStride = strides[shape.count - 1]
        } else {
          rowStride = strides[0]
          colStride = strides[1]
        }
        for r in 0..<rows {
          for c in 0..<cols {
            flat[r * cols + c] = ptr[r * rowStride + c * colStride]
          }
        }
      } else {
        for i in 0..<count {
          flat[i] = array[i].floatValue
        }
      }
    } else {
      for i in 0..<count {
        flat[i] = array[i].floatValue
      }
    }

    var out = [[Float]]()
    out.reserveCapacity(rows)
    for r in 0..<rows {
      let start = r * cols
      out.append(Array(flat[start..<(start + cols)]))
    }
    return out
  }

  /// Copy channel-first encoder `[dim, frames]` into time-major `[frames][dim]`.
  static func copyChannelFirstToTimeMajor(from array: MLMultiArray, dim: Int, frames: Int) -> [[Float]] {
    guard dim > 0, frames > 0 else { return [] }
    var out = Array(repeating: [Float](repeating: 0, count: dim), count: frames)
    if array.dataType == .float32, isContiguousFloat32(array, elementCount: dim * frames) {
      let src = array.dataPointer.bindMemory(to: Float.self, capacity: dim * frames)
      for d in 0..<dim {
        let rowBase = d * frames
        for t in 0..<frames {
          out[t][d] = src[rowBase + t]
        }
      }
      return out
    }
    for d in 0..<dim {
      for t in 0..<frames {
        out[t][d] = array[d * frames + t].floatValue
      }
    }
    return out
  }

  private static func isContiguousFloat32(_ array: MLMultiArray, elementCount: Int) -> Bool {
    guard array.dataType == .float32 else { return false }
    guard array.count >= elementCount else { return false }
    let strides = array.strides.map(\.intValue)
    guard let last = strides.last, last == 1 else { return false }
    // Product of trailing dims should match linear packing for leading dims we care about.
    var expected = 1
    for i in stride(from: strides.count - 1, through: 0, by: -1) {
      if strides[i] != expected { return false }
      let dim = array.shape[i].intValue
      expected *= dim
    }
    return true
  }
}
