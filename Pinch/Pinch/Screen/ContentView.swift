//
//  ContentView.swift
//  Pinch
//
//  Created by Supapon Pucknavin on 24/9/2565 BE.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    
    @State private var isAnimationg: Bool = false
    @State private var imageScale: CGFloat = 1
    
    
    // MARK: - FUNCTION
    
    // MARK: - CONTENT
    
    
    var body: some View {
        NavigationView {
            
            ZStack{
                
                // MARK: - PAGE IMAGE
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x:2, y: 2)
                    .opacity(isAnimationg ? 1: 0)
                    .scaleEffect(imageScale)
                
                //MAKEL - 1. TAP GESTURE
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        }else{
                            withAnimation(.spring()){
                                imageScale = 1
                            }
                        }
                    }
                   
            }//: ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)){
                    isAnimationg = true
                }
            }
            
        }//: NAVIGATION
        .navigationViewStyle(.stack)
    }
}


// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}