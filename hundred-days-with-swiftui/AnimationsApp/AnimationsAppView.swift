//
//  AnimationsAppView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 7/2/23.
//

import SwiftUI

// MARK: - DAY 32-34
struct AnimationsAppView: View {
    // MARK: - Properties
    @State private var animationAmount = 1.0
    @State private var animationAmount2 = 1.0
    @State private var enabled = false
    @State private var enabled2 = false
    @State private var dragAmount = CGSize.zero
    
    let letters = Array("Hello SwiftUI")
    @State private var enabled3 = false
    @State private var dragAmount3 = CGSize.zero
    
    @State private var isShowingRed = false
    
    // MARK: - View
    var body: some View {
        //ScrollView {
            VStack {
                Button("Tap Me") {
                    animationAmount += 1
                }
                .padding(50)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.red)
                        .scaleEffect(animationAmount)
                        .opacity(2 - animationAmount)
                        .animation(
                            .easeOut(duration: 1)
                            .repeatForever(autoreverses: false),
                            value: animationAmount
                        )
                )
                .scaleEffect(animationAmount)
                .blur(radius: (animationAmount - 1) * 3)
                .animation(.easeIn(duration: 2).delay(1).repeatCount(3, autoreverses: true), value: animationAmount)
                .animation(.interpolatingSpring(stiffness: 50, damping: 1), value: animationAmount)
                
                Section {
                    Button("Tap Me") {
                        //animationAmount += 1
                    }
                    .padding(50)
                    .background(.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(.red)
                            .scaleEffect(animationAmount)
                            .opacity(2 - animationAmount)
                            .animation(
                                .easeOut(duration: 1)
                                .repeatForever(autoreverses: false),
                                value: animationAmount
                            )
                    )
                }
                
                Section {
                    Stepper("Scale amount", value: $animationAmount2.animation(), in: 1...10)
                    
                    
                    Text("Tap Me")
                        .padding(40)
                        .background(.red)
                        .foregroundColor(.white)
                        .clipShape(Rectangle())
                        .scaleEffect(animationAmount2)
                }
                
                Section {
                    Button("Tap Me") {
                        enabled.toggle()
                    }
                    .frame(width: 200, height: 200)
                    .background(enabled ? .blue : .red)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
                    .animation(.default, value: enabled)
                }
                
                Section {
                    Button("Tap Me") {
                        enabled2.toggle()
                    }
                    .frame(width: 200, height: 200)
                    .background(enabled2 ? .blue : .red)
                    .animation(.default, value: enabled2) /// It's possible to pass nil into the first argument to disable animations
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: enabled2 ? 60 : 0))
                    .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled2)
                }
                
                Section {
                    LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width: 300, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(dragAmount)
                        .gesture(
                            DragGesture()
                                .onChanged { dragAmount = $0.translation }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        dragAmount = .zero
                                    }
                                }
                        )
                        .animation(.spring(), value: dragAmount)
                }
                
                Section {
                    HStack(spacing: 0) {
                        ForEach(0..<letters.count, id: \.self) { num in
                            Text(String(letters[num]))
                                .padding(5)
                                .font(.title)
                                .background(enabled3 ? .blue : .red)
                                .offset(dragAmount3)
                                .animation(.default.delay(Double(num) / 20), value: dragAmount3)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { dragAmount3 = $0.translation }
                            .onEnded { _ in
                                dragAmount3 = .zero
                                enabled3.toggle()
                            }
                    )
                }
                Section {
                    VStack {
                        Button("Tap Me") {
                            withAnimation {
                                isShowingRed.toggle()
                            }
                        }
                        if isShowingRed {
                            Rectangle()
                                .fill(.red)
                                .frame(width: 200, height: 200)
                                .transition(.asymmetric(insertion: .scale, removal: .opacity)) /// Adds a transition for when animating. WIth .asymmetric you can add a different transition for insertion and removal
                        }
                    }
                }
                
                Section {
                    ZStack {
                                Rectangle()
                                    .fill(.blue)
                                    .frame(width: 200, height: 200)

                                if isShowingRed {
                                    Rectangle()
                                        .fill(.red)
                                        .frame(width: 200, height: 200)
                                        .transition(.pivot)
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    isShowingRed.toggle()
                                }
                            }
                }
            
            
            }
      //  }
        .onAppear {
            animationAmount = 2
        }
    }
    
    // MARK: - Methods
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}
