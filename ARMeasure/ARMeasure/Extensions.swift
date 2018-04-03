//
//  Extensions.swift
//  ARMeasure
//
//  Created by mac126 on 2018/4/3.
//  Copyright © 2018年 mac126. All rights reserved.
//

import Foundation
import ARKit

extension SCNVector3: Equatable {

    /// 从4x4矩阵获取位置
    static func positon(FromTransform transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    /// 空间中两个点的距离
    func distance(from vector: SCNVector3) -> Float {
        let distanceX = self.x - vector.x
        let distanceY = self.y - vector.y
        let distanceZ = self.z - vector.z
        return sqrtf(distanceX * distanceX + distanceY * distanceY + distanceZ * distanceZ)
    }
    
    /// 空间中两个点是否相等
    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
}

extension ARSCNView {
    
    /// 点击屏幕hitTest获取击中的点
    func realWorldVector(screenPostion: CGPoint) -> SCNVector3? {
        let hitTestResults = self.hitTest(screenPostion, types: .featurePoint)
        if let hitTestResult = hitTestResults.first {
            return SCNVector3.positon(FromTransform: hitTestResult.worldTransform)
        }
        return nil
    }
}
