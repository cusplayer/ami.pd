//
//  RegisterUIView.swift
//  ami
//
//  Created by Artem Kufaev on 29.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import SwiftUI
import DesignKit

struct RegisterUIView: View {
    
    var body: some View {
        VStack {
            RegisterFields()
            RegisterButtons()
        }
        .padding(.horizontal, 20)
    }
}

struct RegisterFields: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack {
            Text("Регистрация")
                .padding(.bottom, 50)
                .foregroundColor(ColorPalette.main.color())
                .font(FontLib.bloggerSansMedium.font(size: 24))
            Text("Введите ваши данные")
                .padding(.bottom, 50)
            VStack(alignment: .leading) {
                LabelTextField(
                    keyboardType: .emailAddress,
                    returnKeyType: .next,
                    textContentType: .emailAddress,
                    tag: 0,
                    content: self.email,
                    placeHolder: "Email",
                    isSecure: false)
                LabelTextField(
                    keyboardType: .default,
                    returnKeyType: .next,
                    textContentType: .password,
                    tag: 1,
                    content: self.password,
                    placeHolder: "Пароль",
                    isSecure: true)
                LabelTextField(
                    keyboardType: .default,
                    returnKeyType: .send,
                    textContentType: .newPassword,
                    tag: 2,
                    content: self.confirmPassword,
                    placeHolder: "Повторите пароль",
                    isSecure: true)
            }
            .listRowInsets(EdgeInsets())
        }
        .keyboardAdaptive()
    }
    
}

struct RegisterButtons: View {
    var body: some View {
        VStack {
            RoundedButton(text: "Уже есть аккаунт? Войти!", color: Color.green) {
                print("hello!")
            }
            Divider()
                .padding(.vertical, 10)
            RoundedButton(text: "Продолжить", color: Color.gray) {
                print("hello!")
            }
        }
        .padding(.bottom, 20)
    }
}

struct RoundedButton: View {
    var text: String
    var color: Color
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text)
                    .font(.headline)
                    .foregroundColor(Color.white)
                Spacer()
            }
        }
        .padding(.vertical, 13.0)
        .background(color)
        .cornerRadius(8.0)
    }
}

struct KeyboardTypeView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardTypeView()
    }
}
struct KeyboardTypeView: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var focused: [Bool] = [true, false]

    var body: some View {
        Form {
            Section(header: Text("Your Info")) {
                TextFieldTyped(keyboardType: .default, returnVal: .next, tag: 0, text: self.$firstName, isfocusAble: self.$focused)
                TextFieldTyped(keyboardType: .default, returnVal: .done, tag: 1, text: self.$lastName, isfocusAble: self.$focused)
                Text("Full Name :" + self.firstName + " " + self.lastName)
            }
        }
    }
}

struct TextFieldTyped: UIViewRepresentable {
    let keyboardType: UIKeyboardType
    let returnVal: UIReturnKeyType
    let tag: Int
    @Binding var text: String
    @Binding var isfocusAble: [Bool]

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.keyboardType = self.keyboardType
        textField.returnKeyType = self.returnVal
        textField.tag = self.tag
        textField.delegate = context.coordinator
        textField.autocorrectionType = .no

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if isfocusAble[tag] {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldTyped

        init(_ textField: TextFieldTyped) {
            self.parent = textField
        }

        func updatefocus(textfield: UITextField) {
            textfield.becomeFirstResponder()
        }

func textFieldShouldReturn(_ textField: UITextField) -> Bool {

            if parent.tag == 0 {
                parent.isfocusAble = [false, true]
                parent.text = textField.text ?? ""
            } else if parent.tag == 1 {
                parent.isfocusAble = [false, false]
                parent.text = textField.text ?? ""
         }
        return true
        }

    }
}
