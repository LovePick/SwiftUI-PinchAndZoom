//
//  ContentView.swift
//  Pinch
//
//  Created by Supapon Pucknavin on 24/9/2565 BE.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = CGSize.zero
    @State private var isDrawerOpen: Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    
    // MARK: - FUNCTION
    func resetImageState() {
   
        return withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
         
        }
    }
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    // MARK: - CONTENT
    
    var body: some View {
        NavigationView {
            
            ZStack{
                Color.clear
                // MARK: - PAGE IMAGE
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x:2, y: 2)
                    .opacity(isAnimating ? 1: 0)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                
                //MARE: - 1. TAP GESTURE
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 5
                                
                            }
                        }else{
                            resetImageState()
                            
                        }
                    }//: TAP GESTURE
                //MARK: - 2. DRAG GESTURE
                    .gesture(DragGesture()
                        .onChanged{ value in
                            withAnimation(.linear(duration: 1)){
                                if imageScale <= 1  {
                                    imageOffset = value.translation
                                }else{
                                    imageOffset = value.translation

                                }
                                
                               
                            }
                        }
                        .onEnded{ value in
                            if imageScale <= 1 {
                                resetImageState()
                            }
                            
                          
                        }
                    )//: DRAG GESTURE
                // MARK: - 3. MAGIFICATION
                    .gesture(
                        MagnificationGesture()
                            .onChanged{ value in
                                withAnimation(.linear(duration: 1)){
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded{ _ in
                                
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                                      
                    
                    )//: MAGIFICATION GESTURE
                
            }//: ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            }
            
            //MAKE: - INFO PANEL
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            // MARK: - CONTROLS
            .overlay(
                Group{
                    HStack{
                        // SCALE DOWN
                        Button{
                            withAnimation(.spring()){
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                           ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        // RESET
                        Button{
                            resetImageState()
                        } label: {
                           ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // SCALE UP
                        Button{
                            withAnimation(.spring()){
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                           ControlImageView(icon: "plus.magnifyingglass")
                        }
                        
                    }//: HSTACK
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    
                }
                    .padding(.bottom, 30)
                , alignment: .bottom
            )//: CONTROLS
            
            //MARK: - DRAWER
            .overlay(
                HStack(spacing: 12){
                    // MARK: - DRAWER HANDLE
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut){
                                isDrawerOpen.toggle()
                            }
                        }
                    
                    // MARK: - THUMBNAILS
                    ForEach(pages) { item in
                        Image(item.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration:0.5), value: isDrawerOpen)
                            .onTapGesture(perform:{
                                isAnimating = true
                                pageIndex = item.id
                            })
                    }
                    Spacer()
                    
                }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background( .ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                
                , alignment: .topTrailing
            )//MARK: DRAWER
            
            
        }//: NAVIGATION
        .navigationViewStyle(.stack)
        .onTapGesture(count: 3) {
            if(imageScale > 1){
                resetImageState()
            }
        }
    }
}


// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
