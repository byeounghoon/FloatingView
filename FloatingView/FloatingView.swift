//
//  FloatingView.swift
//  FloatingView
//
//  Created by Lau on 8/21/25.
//

import SwiftUI

struct FloatingView: View {
    @State private var position = CGPoint(x: 100, y: 200)
    @State private var dragOffset = CGSize.zero
    @State private var isDragging = false
    
    // 화면 크기 캐시
    private let screenSize = UIScreen.main.bounds
    
    var body: some View {
        GeometryReader { geometry in
            let width = screenSize.width / 2
            let height = width * 9/16
            
            // 리퀴드 글래스 배경 (16:9 비율)
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .background(
                    // 리퀴드 굴절 효과 (드래그 중에는 간소화)
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(isDragging ? 0.1 : 0.15),
                                    .white.opacity(isDragging ? 0.05 : 0.08),
                                    .clear,
                                    .white.opacity(isDragging ? 0.03 : 0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blur(radius: isDragging ? 0 : 0.5)
                )
                .overlay(
                    // 상단 리퀴드 하이라이트
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(isDragging ? 0.4 : 0.6),
                                    .white.opacity(isDragging ? 0.2 : 0.3),
                                    .white.opacity(isDragging ? 0.05 : 0.1),
                                    .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isDragging ? 0.8 : 1.2
                        )
                )
                .overlay(
                    // 내부 리퀴드 반사 (드래그 중에는 제거)
                    Group {
                        if !isDragging {
                            RoundedRectangle(cornerRadius: 26)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.25),
                                            .clear,
                                            .clear,
                                            .white.opacity(0.15)
                                        ],
                                        startPoint: UnitPoint(x: 0.2, y: 0.2),
                                        endPoint: UnitPoint(x: 0.8, y: 0.8)
                                    ),
                                    lineWidth: 0.6
                                )
                                .padding(1.5)
                        }
                    }
                )
                .overlay(
                    // 리퀴드 굴절 디테일 (드래그 중에는 제거)
                    Group {
                        if !isDragging {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            .white.opacity(0.12),
                                            .clear
                                        ],
                                        center: .center,
                                        startRadius: 15,
                                        endRadius: 80
                                    )
                                )
                                .blendMode(.overlay)
                        }
                    }
                )
                .overlay(
                    // 내용
                    VStack(spacing: 14) {
                        // 상단 아이콘
                        Image(systemName: "flame.fill")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.95),
                                        .white.opacity(0.8),
                                        .white.opacity(0.7)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .white.opacity(isDragging ? 0.1 : 0.3), radius: isDragging ? 3 : 6, x: 0, y: 2)
                            .shadow(color: .black.opacity(isDragging ? 0.05 : 0.1), radius: isDragging ? 1 : 2, x: 0, y: 1)
                        
                        // 제목
                        Text("플로팅뷰")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.9),
                                        .white.opacity(0.75)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(color: .white.opacity(isDragging ? 0.1 : 0.2), radius: isDragging ? 1 : 3, x: 0, y: 1)
                            .shadow(color: .black.opacity(isDragging ? 0.05 : 0.15), radius: 1, x: 0, y: 0.5)
                        
                        // 설명
                        Text("드래그하여 이동")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.7),
                                        .white.opacity(0.55)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(color: .black.opacity(isDragging ? 0.05 : 0.1), radius: 1, x: 0, y: 0.5)
                    }
                    .padding(20)
                )
                .shadow(color: .black.opacity(isDragging ? 0.08 : 0.12), radius: isDragging ? 15 : 25, x: 0, y: isDragging ? 8 : 12)
                .shadow(color: .black.opacity(isDragging ? 0.03 : 0.06), radius: isDragging ? 4 : 8, x: 0, y: 4)
                .shadow(color: .white.opacity(isDragging ? 0.05 : 0.1), radius: 1, x: 0, y: -1)
                .frame(width: width, height: height)
                .position(
                    x: max(width/2, min(screenSize.width - width/2, position.x)),
                    y: max(geometry.safeAreaInsets.top + height/2, min(screenSize.height - geometry.safeAreaInsets.bottom - height/2, position.y))
                )
                .scaleEffect(isDragging ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isDragging)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // 드래그 시작 감지
                            if !isDragging {
                                isDragging = true
                            }
                            
                            // 드래그 시작 시점의 오프셋을 고려하여 위치 계산
                            let newX = position.x + value.translation.width - dragOffset.width
                            let newY = position.y + value.translation.height - dragOffset.height
                            
                            // SafeArea 경계 내에서만 이동 가능
                            let minX = width/2
                            let maxX = screenSize.width - width/2
                            let minY = geometry.safeAreaInsets.top + height/2
                            let maxY = screenSize.height - geometry.safeAreaInsets.bottom - height/2
                            
                            position.x = max(minX, min(maxX, newX))
                            position.y = max(minY, min(maxY, newY))
                            
                            dragOffset = value.translation
                        }
                        .onEnded { _ in
                            // 드래그가 끝나면 오프셋 초기화
                            dragOffset = .zero
                            isDragging = false
                        }
                )
        }
    }
}

#Preview {
 
    FloatingView()
 
} 
