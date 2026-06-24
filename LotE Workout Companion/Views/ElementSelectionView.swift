//
//  ElementSelectionView.swift
//  LotE Workout Companion
//
//  Created by Antigravity on 6/23/26.
//

import SwiftUI

struct ElementSelectionView: View {
    @ObservedObject var profileManager: UserProfileManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var localElementIndex: Int = 0
    @State private var localExpression: ExpressionStyle = .standard
    
    var activeElement: LotEElement {
        UserProfileManager.availableElements[localElementIndex]
    }
    
    var body: some View {
        ZStack {
            // Element themed dark background
            Color(hex: "#050505")
                .ignoresSafeArea()
            
            // Dynamic thematic background glow
            Circle()
                .fill(activeElement.primaryColor.opacity(0.12))
                .frame(width: 320, height: 320)
                .blur(radius: 90)
                .position(x: 100, y: 150)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("RESONANCE CHAMBER")
                        .font(.custom("Orbitron-Bold", size: 22).bold())
                        .foregroundColor(.white)
                        .tracking(3)
                    
                    Text("Tune your elemental wavelength and stance")
                        .font(.custom("Exo2-Medium", size: 13))
                        .foregroundColor(.gray)
                }
                .padding(.top, 25)
                .padding(.bottom, 15)
                
                // Horizontal scroll list of elements
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(0..<UserProfileManager.availableElements.count, id: \.self) { idx in
                            let elem = UserProfileManager.availableElements[idx]
                            let isSelected = localElementIndex == idx
                            
                            Button(action: {
                                withAnimation(.spring()) {
                                    localElementIndex = idx
                                    // Handle Tenebrie genetic enforcement
                                    if elem.inherentDark {
                                        localExpression = .corrupt
                                    } else if localExpression == .corrupt && elem.name == "Water" {
                                        localExpression = .corrupt
                                    }
                                }
                            }) {
                                Text(elem.name.uppercased())
                                    .font(.custom("Orbitron-Bold", size: 12).bold())
                                    .foregroundColor(isSelected ? .white : .gray)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(isSelected ? elem.primaryColor : Color.white.opacity(0.03))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(isSelected ? elem.accentColor : Color.white.opacity(0.1), lineWidth: 1)
                                            )
                                    )
                                    .shadow(color: isSelected ? elem.primaryColor.opacity(0.4) : Color.clear, radius: 4)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 50)
                .padding(.bottom, 15)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Expression Selector Stance (Standard vs Corrupted vs Balanced)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ELEMENTAL EXPRESSION STANCE")
                                .font(.custom("Orbitron-Bold", size: 12).bold())
                                .foregroundColor(.gray)
                                .tracking(2)
                                .padding(.horizontal)
                            
                            HStack(spacing: 10) {
                                ForEach(ExpressionStyle.allCases, id: \.self) { style in
                                    let isSel = localExpression == style
                                    let isDisabled = activeElement.inherentDark && style != .corrupt
                                    
                                    Button(action: {
                                        if !isDisabled {
                                            localExpression = style
                                        }
                                    }) {
                                        Text(style.rawValue)
                                            .font(.custom("Exo2-Bold", size: 11))
                                            .foregroundColor(isSel ? .white : (isDisabled ? .white.opacity(0.15) : .gray))
                                            .padding(.vertical, 12)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(isSel ? activeElement.primaryColor : Color.white.opacity(0.02))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(isSel ? activeElement.accentColor : Color.white.opacity(0.08), lineWidth: 1)
                                                    )
                                            )
                                    }
                                    .disabled(isDisabled)
                                }
                            }
                            .padding(.horizontal)
                            
                            if activeElement.inherentDark {
                                Text("⚠️ Tenebrie elements are inherently corruptive. Standard Light alignment is locked by lore.")
                                    .font(.caption2)
                                    .foregroundColor(.red.opacity(0.8))
                                    .padding(.horizontal)
                                    .padding(.top, 4)
                            }
                        }
                        
                        // Element Lore Card
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text(activeElement.displayName(for: localExpression).uppercased())
                                    .font(.custom("Orbitron-Bold", size: 20).bold())
                                    .foregroundColor(activeElement.primaryColor)
                                    .tracking(2)
                                
                                Spacer()
                                
                                Text(activeElement.planetOfOrigin.uppercased())
                                    .font(.custom("Orbitron-Bold", size: 11).bold())
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(6)
                            }
                            
                            // Cultural Description
                            Text(activeElement.description)
                                .font(.custom("Exo2-Medium", size: 14))
                                .foregroundColor(.white)
                                .lineSpacing(4)
                            
                            Divider()
                                .background(Color.white.opacity(0.1))
                            
                            // Stance Details
                            VStack(alignment: .leading, spacing: 8) {
                                Text("STANCE MANIFESTATION")
                                    .font(.custom("Orbitron-Bold", size: 11).bold())
                                    .foregroundColor(.gray)
                                    .tracking(2)
                                
                                let stanceText: String = {
                                    switch localExpression {
                                    case .standard: return activeElement.standardDetails
                                    case .corrupt: return activeElement.corruptDetails
                                    case .balanced: return activeElement.balancedDetails
                                    }
                                }()
                                
                                Text(stanceText)
                                    .font(.custom("Exo2-Regular", size: 13))
                                    .foregroundColor(.white.opacity(0.8))
                                    .lineSpacing(4)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.02))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(activeElement.primaryColor.opacity(0.3), lineWidth: 1.5)
                                )
                        )
                        .padding(.horizontal)
                        
                        // Save Button
                        Button(action: {
                            saveSelection()
                        }) {
                            Text("ALIGN SOUL CHANNELS")
                                .font(.custom("Orbitron-Bold", size: 15).bold())
                                .foregroundColor(.white)
                                .tracking(2)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(activeElement.primaryColor)
                                        .shadow(color: activeElement.primaryColor.opacity(0.4), radius: 6)
                                )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .onAppear {
            localElementIndex = profileManager.selectedElementIndex
            localExpression = profileManager.expressionStyle
        }
    }
    
    private func saveSelection() {
        profileManager.selectedElementIndex = localElementIndex
        profileManager.expressionStyle = localExpression
        presentationMode.wrappedValue.dismiss()
    }
}
