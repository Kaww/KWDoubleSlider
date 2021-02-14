//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by kaww on 14/02/2021.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct KWDoubleSlider: View {
    var inactiveColor: Color
    var activeColor: Color
    var handleColor: Color
    
    @State var trackHeight: CGFloat
    @State var handleSize: CGFloat
    
    @Binding var pos1: CGFloat
    @Binding var pos2: CGFloat
    
    var widthFactor: CGFloat { return pos2 - pos1 }
    
    public init(
        pos1: Binding<CGFloat>,
        pos2: Binding<CGFloat>,
        inactiveColor: Color = Color.black.opacity(0.2),
        activeColor: Color = Color.blue,
        handleColor: Color = .white,
        trackThickness: CGFloat = 5,
        handleDiameter: CGFloat = 25
    ) {
        _pos1 = pos1
        _pos2 = pos2
        self.inactiveColor = inactiveColor
        self.activeColor = activeColor
        self.handleColor = handleColor
        _trackHeight = State(initialValue: trackThickness)
        _handleSize = State(initialValue: handleDiameter)
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                // Track background
                RoundedRectangle(cornerRadius: trackHeight / 2)
                    .foregroundColor(inactiveColor)
                    .frame(height: trackHeight, alignment: .center)
                
                // Active track
                Rectangle()
                    .foregroundColor(activeColor)
                    .frame(
                        width: geometry.size.width * widthFactor,
                        height: trackHeight,
                        alignment: .center
                    )
                    .position(
                        x: geometry.size.width * (pos1 + widthFactor / 2.0),
                        y: geometry.size.height / 2
                    )
                    .shadow(color: activeColor.opacity(0.6), radius: 5)
                
                // Handles
                Circle()
                    .foregroundColor(handleColor)
                    .frame(width: handleSize, height: handleSize, alignment: .center)
                    .position(
                        x: geometry.size.width * pos1,
                        y: geometry.size.height / 2
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newPos = value.location.x / geometry.size.width
                                
                                if newPos < 0 { pos1 = 0 }
                                else if newPos > (pos2 - 0.05) { pos1 = pos2 - 0.05 }
                                else { pos1 = newPos }
                            }
                    )
                
                Circle()
                    .foregroundColor(handleColor)
                    .frame(width: handleSize, height: handleSize, alignment: .center)
                    .position(
                        x: geometry.size.width * pos2,
                        y: geometry.size.height / 2
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newPos = value.location.x / geometry.size.width
                                
                                if newPos > 1 { pos2 = 1 }
                                else if newPos < (pos1 + 0.05) { pos2 = pos1 + 0.05 }
                                else { pos2 = newPos }
                            }
                    )
            }
        }
    }
}
