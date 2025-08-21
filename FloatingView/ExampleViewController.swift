//
//  ExampleViewController.swift
//  FloatingView
//
//  Created by Lau on 8/21/25.
//

import UIKit

class ExampleViewController: UIViewController {
    
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 플로팅뷰 추가
        addFloatingView()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 테스트 버튼이 코드로 생성되는 경우
        if testButton == nil {
            testButton = UIButton(type: .system)
            testButton.setTitle("테스트 버튼", for: .normal)
            testButton.backgroundColor = .systemBlue
            testButton.setTitleColor(.white, for: .normal)
            testButton.layer.cornerRadius = 8
            testButton.addTarget(self, action: #selector(testButtonTapped), for: .touchUpInside)
            
            view.addSubview(testButton)
            testButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                testButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
                testButton.widthAnchor.constraint(equalToConstant: 200),
                testButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        // 텍스트 필드가 코드로 생성되는 경우
        if textField == nil {
            textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.placeholder = "터치 테스트용 텍스트 필드"
            
            view.addSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                textField.widthAnchor.constraint(equalToConstant: 250),
                textField.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
    }
    
    @objc private func testButtonTapped() {
        let alert = UIAlertController(title: "성공!", message: "UIKit 버튼이 정상적으로 터치되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func testButtonAction(_ sender: UIButton) {
        testButtonTapped()
    }
}

// MARK: - 더 간단한 사용법
extension ExampleViewController {
    
    /// 플로팅뷰 토글
    @objc func toggleFloatingView() {
        if children.contains(where: { $0 is FloatingViewWrapper }) {
            removeFloatingView()
        } else {
            addFloatingView()
        }
    }
} 