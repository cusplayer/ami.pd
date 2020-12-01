//
//  AuthValidator.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Validator

class AuthValidator {
    
    enum ValidationErrors: String, ValidationError {
        case emailInvalid = "Email не корректен"
        case passwordInvalid = "Слабый пароль"
        case passwordNotConfirm = "Пароли не совпадают"
        var message: String { return self.rawValue }
    }
    
    public func validateEmail(_ email: UITextField) -> Bool {
        let rule = ValidationRulePattern(pattern: EmailValidationPattern.standard,
                                         error: ValidationErrors.emailInvalid)
        return email.validate(rule: rule).isValid
    }
    
    public func validatePassword(_ password: UITextField) -> Bool {
        let rule = ValidationRuleLength(min: 5,
                                        max: 20,
                                        error: ValidationErrors.passwordInvalid)
        return password.validate(rule: rule).isValid
    }
    
    public func validateConfirmPassword(password: UITextField,
                                        confirmPassword: UITextField) -> Bool {
        let rule = ValidationRuleEquality<String>(dynamicTarget: {
            return password.text ?? ""
        }, error: ValidationErrors.passwordNotConfirm)
        return confirmPassword.validate(rule: rule).isValid
    }
    
}
