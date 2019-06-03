//
//  AuthCoordinatorTest.swift
//  ApplicationCoordinator
//
//  Created by Andrey on 04.09.16.
//  Copyright © 2016 Andrey Panov. All rights reserved.
//

import XCTest
@testable import ApplicationCoordinator

class AuthCoordinatorTest: XCTestCase {
    
    private var coordinator: Coordinator!
    private var router: RouterMockProtocol!
    
    private var loginPresentable: LoginPresentable!
    private var signUpPresentable: SignUpPresentable!
    private var termsPresentable: TermsPresentable!

    private var signUpController: SignUpController!

    override func setUp() {
        super.setUp()
        
        router = RouterMock()
        
        let loginController = LoginController.controllerFromStoryboard(.auth)
        signUpController = SignUpController.controllerFromStoryboard(.auth)
        signUpController.view.isHidden = false
        let termsController = TermsController.controllerFromStoryboard(.auth)
        let factory = AuthPresentableFactoryMock(loginController: loginController,
                                            signUpController: signUpController,
                                            termsController: termsController)
        coordinator = AuthCoordinator(router: router, factory: factory)
        
        loginPresentable = loginController
        signUpPresentable = signUpController
        termsPresentable = termsController
    }
    
    override func tearDown() {
        coordinator = nil
        router = nil
        loginPresentable = nil
        signUpPresentable = nil
        termsPresentable = nil
        
        super.tearDown()
    }
    
    func testStart() {
        
        coordinator.start()
        // showLogin() must call
        XCTAssertTrue(router.navigationStack.first is LoginController)
        XCTAssertTrue(router.navigationStack.count == 1)
    }
    
    func testShowSignUp() {
        
        coordinator.start()
        // onSignUpButtonTap event
        loginPresentable.onSignUpButtonTap!()
        XCTAssertTrue(router.navigationStack.last is SignUpController)
        XCTAssertTrue(router.navigationStack.count == 2)
    }
    
    func testShowTerms() {
        
        //show login controller
        coordinator.start()
        // show signUp controller
        loginPresentable.onSignUpButtonTap!()
        //show terms controller
        signUpPresentable.onTermsButtonTap!()
        XCTAssertTrue(router.navigationStack.last is TermsController)
        XCTAssertTrue(router.navigationStack.count == 3)
    }
}

final class AuthPresentableFactoryMock: AuthPresentableFactory {
    
    private let loginController: LoginController
    private let signUpController: SignUpController
    private let termsController: TermsController
    
    init(loginController: LoginController,
         signUpController: SignUpController,
         termsController: TermsController) {
        
        self.loginController = loginController
        self.signUpController = signUpController
        self.termsController = termsController
    }
    
    func makeLoginPresentable() -> LoginPresentable {
        return loginController
    }
    
    func makeSignUpPresentable() -> SignUpPresentable {
        return signUpController
    }
    
    func makeTermsPresentable() -> TermsPresentable {
        return termsController
    }
}
