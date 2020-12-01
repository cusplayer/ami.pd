//
//  GraphicHelper.swift
//  UIUtils
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import CoreGraphics

public class GraphicHelper {
    
    private static var cache: [String: CGSize] = [:]
    
    private static func createHash(rectangleSize: CGSize,
                                   squareCount: Int) -> String {
        return "\(rectangleSize)\(squareCount)"
    }
    
    private static func saveToCache(rectangleSize: CGSize,
                                    squareCount: Int,
                                    squareSize: CGSize) {
        let hash = createHash(rectangleSize: rectangleSize, squareCount: squareCount)
        cache[hash] = squareSize
    }
    
    private static func getFromCache(rectangleSize: CGSize,
                                     squareCount: Int) -> CGSize? {
        let hash = createHash(rectangleSize: rectangleSize, squareCount: squareCount)
        return cache[hash]
    }
    
    public static func calculateSizeOfSquaresInRectangle(rectangleSize: CGSize,
                                                         squareCount N: Int) -> CGSize {
        if let size = getFromCache(rectangleSize: rectangleSize, squareCount: N) {
            return size
        }
        // 1. Посчитать площадь прямоугольника S = A*B, где A,B - стороны прямоугольника.
        let A = rectangleSize.width
        let B = rectangleSize.height
        let S = A * B
        
        // 2. Поделить площадь на N: q = S/N, где N - количество размещаемых квадратов.
        let q = S / CGFloat(N)
        
        // 3. Извлечь квадратный корень из результата a = sqrt(q).
        let a = sqrt(q)
        
        // 4. Если rem(A/a) = rem(B/a) = 0, то сторона искомого квадрата x = a.
        let remA = A.truncatingRemainder(dividingBy: a)
        let remB = B.truncatingRemainder(dividingBy: a)
        if remA == remB, remB == 0 {
            let size = CGSize(width: a, height: a)
            saveToCache(rectangleSize: rectangleSize,
                        squareCount: N,
                        squareSize: size)
            return size
        } else {
            // 5. Поделить стороны прямоугольника на результат a и вычесть остаток от деления из a: ra = a-rem(A/a), rb = a-rem(B/a).
            let ra = a - remA
            let rb = a - remB

            // 6. x1 = a - ra/(div(A/a)+1), где div(A/a) - целая часть от результата деления A/a.
            var x1 = a - ra / CGFloat(Int(A / a) + 1)

            // 7. x2 = a - rb/(div(B/a)+1).
            var x2 = a - rb / CGFloat(Int(B / a) + 1)

            // 8. m = N*x1/A ( + 1, если rem(N*x1/A) > 0).
            var m = CGFloat(N) * x1 / A
            if (CGFloat(N) * x1).truncatingRemainder(dividingBy: A) > 0 {
                m += 1
            }

            // 9. n = N*x2/B ( + 1, если rem(N*x2/B) > 0).
            var n = CGFloat(N) * x2 / B
            if (CGFloat(N) * x2).truncatingRemainder(dividingBy: B) > 0 {
                n += 1
            }
            
            // 10. Если m*x1 > B, то x1 = x1 - (x1-rem(B/x1)) / (div(B/x1)+1).
            if m * x1 > B {
                x1 -= (x1 - B.truncatingRemainder(dividingBy: x1)) / CGFloat(Int(B / x1) + 1)
            }

            // 11. Если n*x2 > A, то x2 = x2 - (x2-rem(A/x2)) / (div(A/x2)+1).
            if n * x2 > A {
                x2 -= (x2 - A.truncatingRemainder(dividingBy: x2)) / CGFloat(Int(A / x2) + 1)
            }
            // 12. Искомый x = max(x1, x2).
            let x = max(x1, x2)
            
            let size = CGSize(width: x, height: x)
            saveToCache(rectangleSize: rectangleSize,
                        squareCount: N,
                        squareSize: size)
            return size
        }
    }
    
}
