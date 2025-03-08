//
//  CardView.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 1/4/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Friend.name) private var allFriends: [Friend]

    @Binding var friendToEdit: Friend?

    @State private var friendToDelete: Friend?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(content: {
            // 1. EG&C: Set the relative frame for the upper view
            friendsCardView
                .containerRelativeFrame(.vertical, { dimension, _  in
                    dimension * 0.35
                })
                .alert("Delete Friend", isPresented: $showingDeleteAlert, presenting: friendToDelete, actions: { friend in
                    Button("Delete", role: .destructive) {
                        modelContext.delete(friend)
                        try? modelContext.save()
                        friendToDelete = nil
                    }
                    
                    Button("Cancel", role: .cancel) {
                        friendToDelete = nil
                    }
                }, message: { friend in
                    Text("Are you sure you want to delete \(friend.getFirstName())?")
                })
            
            Rectangle()
        })
    }
    
    var friendsCardView: some View {
        TabView(content: {
            ForEach(allFriends, content: { friend in
                GeometryReader(content: { geometry in
                    friendCardEntry(for: friend, in: geometry)
                })
            })
            .background(Color.purple)
        })
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
    
    // 2. EG&C: Encapsulate the ZStack in GeometryReader
    private func friendCardEntry(for friend: Friend, in geometry: GeometryProxy) -> some View {
        ZStack(content: {
            RoundedRectangle(cornerRadius: 20)
            
            Text("\(friend.name)")
                .foregroundStyle(.white)
            
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .circularButton(geometry: geometry, heightMultiplier: 0.34)
                .onTapGesture(perform: {
                    friendToEdit = friend
                })
            
            Image(systemName: "trash.circle.fill")
                .resizable()
                .circularButton(geometry: geometry, heightMultiplier: 0.17)
                .onTapGesture(perform: {
                    friendToDelete = friend
                    showingDeleteAlert = true
                })
        })
        .padding()
    }
}

// 3. EG&C: Place the buttons in relative positions
struct CircularButtonModifier: ViewModifier {
    let geometry: GeometryProxy
    let heightMultiplier: Double
    
    func body(content: Content) -> some View {
        content
            .frame(width: 30, height: 30)
            .foregroundStyle(.white)
            .offset(
                x: geometry.frame(in: .local).width * 0.40,
                y: -geometry.frame(in: .local).height * heightMultiplier
            )
    }
}

extension View {
    func circularButton(geometry: GeometryProxy, heightMultiplier: Double) -> some View {
        modifier(
            CircularButtonModifier(
                geometry: geometry,
                heightMultiplier: heightMultiplier
            )
        )
    }
}
