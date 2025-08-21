//
//  FloatingViewWrapper.swift
//  FloatingView
//
//  Created by Lau on 8/21/25.
//

import SwiftUI
import UIKit

// MARK: - UIKit용 플로팅뷰 래퍼
class FloatingViewWrapper: UIViewController {
    private var hostingController: UIHostingController<FloatingViewContainer>?
    private var floatingViewContainer: FloatingViewContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatingView()
    }
    
    init() {
        self.floatingViewContainer = FloatingViewContainer()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.floatingViewContainer = FloatingViewContainer()
        super.init(coder: coder)
    }
    
    private func setupFloatingView() {
        // SwiftUI 뷰를 UIKit에 임베드
        hostingController = UIHostingController(rootView: floatingViewContainer)
        
        guard let hostingController = hostingController else { return }
        
        // 투명 배경 설정
        hostingController.view.backgroundColor = .clear
        
        // 자식 뷰컨트롤러로 추가
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // 전체 화면에 맞춤
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 터치 통과를 위한 커스텀 뷰 설정
        hostingController.view = PassThroughView(frame: view.bounds)
        hostingController.view.backgroundColor = .clear
        
        // SwiftUI 뷰 다시 설정
        let swiftUIView = UIHostingController(rootView: floatingViewContainer)
        swiftUIView.view.backgroundColor = .clear
        hostingController.view.addSubview(swiftUIView.view)
        swiftUIView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            swiftUIView.view.topAnchor.constraint(equalTo: hostingController.view.topAnchor),
            swiftUIView.view.leadingAnchor.constraint(equalTo: hostingController.view.leadingAnchor),
            swiftUIView.view.trailingAnchor.constraint(equalTo: hostingController.view.trailingAnchor),
            swiftUIView.view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor)
        ])
    }
}

// MARK: - 터치 통과 뷰
class PassThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        // 자신이 히트되면 nil을 반환하여 터치를 통과시킴
        if hitView == self {
            return nil
        }
        
        return hitView
    }
}

// MARK: - SwiftUI 컨테이너
struct FloatingViewContainer: View {
    var body: some View {
        // 투명한 배경에 플로팅뷰만 배치
        Color.clear
            .ignoresSafeArea()
            .overlay(
                FloatingView()
                    .allowsHitTesting(true) // 플로팅뷰는 터치 허용
            )
            .allowsHitTesting(false) // 배경은 터치 차단
    }
}

// MARK: - UIKit 뷰컨트롤러 확장
extension UIViewController {
    /// 플로팅뷰를 현재 뷰컨트롤러에 추가
    func addFloatingView() {
        let floatingWrapper = FloatingViewWrapper()
        
        // 자식 뷰컨트롤러로 추가
        addChild(floatingWrapper)
        view.addSubview(floatingWrapper.view)
        floatingWrapper.didMove(toParent: self)
        
        // 전체 화면에 맞춤
        floatingWrapper.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            floatingWrapper.view.topAnchor.constraint(equalTo: view.topAnchor),
            floatingWrapper.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            floatingWrapper.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            floatingWrapper.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 가장 위에 배치
        view.bringSubviewToFront(floatingWrapper.view)
    }
    
    /// 플로팅뷰 제거
    func removeFloatingView() {
        children.forEach { child in
            if child is FloatingViewWrapper {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
    }
} 