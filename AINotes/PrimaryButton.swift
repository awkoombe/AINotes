//
//  PrimaryButton.swift
//  AINotes
//
//  Created by Nor Abdirahman on 11/07/2025.
//


//
//  PrimaryButton.swift
//  Notes
//
//  Created by Nor Abdirahman on 08/07/2025.
//

import SwiftUI

struct PrimaryButton: View {
    var isLoading = false
    var isDisabled = false
    var action: (() -> Void)?
    @State var counter: Int = 0
    @State var origin: CGPoint = .zero
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack {
                if isLoading {
                    LoadingIndicator()
                } else {
                    Image(systemName: "sparkles")
                }
                Text(isLoading ? "Generating..." : "Generate Notes")
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .background(
            ZStack {
                if !isDisabled {
                    AnimatedMeshGradient()
                        .mask(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 16)
                                .blur(radius: 8)
                        )
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 3)
                            .blur(radius: 2)
                            .blendMode(.overlay)
                        )
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 1)
                            .blur(radius: 1)
                            .blendMode(.overlay)
                        )
                }
            }
        )
        .background(Color.black)
        .cornerRadius(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.black.opacity(0.5), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 20)
        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 15)
        .foregroundColor(.white)
        .background(RoundedRectangle(cornerRadius: 16)
            .stroke(.primary.opacity(0.5), lineWidth: 1)
        )
        .disabled(isLoading || isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
        .onPressingChanged { point in
            if !isDisabled {
                if let point {
                    origin = point
                    counter += 1
                } }
        }
        .modifier(RippleEffect(at: origin, trigger: counter))
    }
}

#Preview {
   VStack {
       PrimaryButton(action:{})
       PrimaryButton(isLoading: true, action: {})
       PrimaryButton(isDisabled: true, action: {})
    }
   
        .padding(40)
}
