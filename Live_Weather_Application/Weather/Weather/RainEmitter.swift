//
//  RainEmitter.swift
//  Weather
//
//  Created by Prateek Gupta on 10/06/19.
//  Copyright © 2019 Prateek Gupta. All rights reserved.
//

import UIKit

class RainEmitter{
    
    static func get(with image: UIImage) -> CAEmitterLayer{
        let emitter = CAEmitterLayer()
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterCells = generateEmitterCells(with: image)
        
        return emitter
    }
    
    static func generateEmitterCells(with image: UIImage) -> [CAEmitterCell]{
        var cells = [CAEmitterCell]()
        
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.birthRate = 1
        cell.lifetime = 50
        cell.velocity = CGFloat(100)
        cell.emissionLongitude = (180 * (.pi/180))
        //cell.emissionRange = (45 * (.pi/180))
        
        cell.scale = 0.4
        cell.scaleRange = 0.3
        
        cells.append(cell)
        
        return cells
    }
}
