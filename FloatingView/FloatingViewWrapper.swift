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
        
        // 터치 통과를 위한 커스텀 뷰로 교체
        let passThroughView = PassThroughView(frame: view.bounds)
        passThroughView.backgroundColor = .clear
        
        // 자식 뷰컨트롤러로 추가
        addChild(hostingController)
        passThroughView.addSubview(hostingController.view)
        view.addSubview(passThroughView)
        hostingController.didMove(toParent: self)
        
        // PassThroughView 제약 설정
        passThroughView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passThroughView.topAnchor.constraint(equalTo: view.topAnchor),
            passThroughView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            passThroughView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            passThroughView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // HostingController 뷰 제약 설정
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: passThroughView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: passThroughView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: passThroughView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: passThroughView.bottomAnchor)
        ])
    }
}

// MARK: - 터치 통과 뷰
class PassThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        // SwiftUI 뷰(hostingController.view)가 히트된 경우 그대로 반환
        if let hitView = hitView, hitView != self {
            return hitView
        }
        
        // 자신(PassThroughView)이 히트되면 nil을 반환하여 터치를 통과시킴
        return nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 자식 뷰들을 체크
        for subview in subviews.reversed() {
            let convertedPoint = convert(point, to: subview)
            if subview.point(inside: convertedPoint, with: event) {
                return true
            }
        }
        
        // 자신 영역에는 포인트가 없는 것으로 처리
        return false
    }
}

// MARK: - SwiftUI 컨테이너
struct FloatingViewContainer: View {
    var body: some View {
        // 플로팅뷰만 배치하고 배경은 완전히 제거
        FloatingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .allowsHitTesting(true)
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