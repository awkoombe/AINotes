//
//  SignUpView.swift
//  AINotes
//
//  Created by Nor Abdirahman on 11/07/2025.
//


//
//  SignUpView.swift
//  Notes
//
//  Created by Nor Abdirahman on 09/07/2025.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var emailError: String = ""
    @State private var passwordError: String = ""
    @State private var isLoading: Bool = false
    
    // Animation states
    @State private var animationStates: [Bool] = Array(repeating: false, count: 9)

    var body: some View {
        VStack(spacing: 20) {
            // Title Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Create an account")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 60, y: 30)
                    .opacity(animationStates[0] ? 1 : 0)
                    .offset(y: animationStates[0] ? 0 : -20)
                    .blur(radius: animationStates[0] ? 0 : 4)

                Text("Begin your 30-day complimentary trial immediately.")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
                    .opacity(animationStates[1] ? 1 : 0)
                    .offset(y: animationStates[1] ? 0 : -20)
                    .blur(radius: animationStates[1] ? 0 : 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Email Input
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    TextField("Email address", text: $email)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                        .onChange(of: email) { _, newValue in
                            validateEmail(newValue)
                        }

                    Button(action: {}) {
                        Image(systemName: "envelope.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)
                            .background(
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
                            )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.2))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(emailError.isEmpty ? Color.white.opacity(0.1) : Color.red.opacity(0.7), lineWidth: 1))
                .cornerRadius(10)
                
                if !emailError.isEmpty {
                    Text(emailError)
                        .font(.system(size: 12))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(.leading, 4)
                }
            }
            .opacity(animationStates[2] ? 1 : 0)
            .offset(y: animationStates[2] ? 0 : -20)
            .blur(radius: animationStates[2] ? 0 : 4)

            // Password Input
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Group {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                    }
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
                    .onChange(of: password) { _, newValue in
                        validatePassword(newValue)
                    }

                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)
                            .background(
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
                            )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.2))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(passwordError.isEmpty ? Color.white.opacity(0.1) : Color.red.opacity(0.7), lineWidth: 1))
                .cornerRadius(10)
                
                if !passwordError.isEmpty {
                    Text(passwordError)
                        .font(.system(size: 12))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(.leading, 4)
                }
            }
            .opacity(animationStates[3] ? 1 : 0)
            .offset(y: animationStates[3] ? 0 : -20)
            .blur(radius: animationStates[3] ? 0 : 4)

            // Forgot Password
            Button(action: {}) {
                Text("Forgot password")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .opacity(animationStates[4] ? 1 : 0)
            .offset(y: animationStates[4] ? 0 : -20)
            .blur(radius: animationStates[4] ? 0 : 4)

            // Continue Button
            Button(action: handleSignUp) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Text("Continue")
                            .font(.system(size: 17))
                        Image(systemName: "chevron.right")
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isFormValid ? Color.blue : Color.gray.opacity(0.5))
                .cornerRadius(10)
            }
            .disabled(!isFormValid || isLoading)
            .opacity(animationStates[5] ? 1 : 0)
            .offset(y: animationStates[5] ? 0 : -20)
            .blur(radius: animationStates[5] ? 0 : 4)

            // Divider
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 1)
                .opacity(animationStates[6] ? 1 : 0)
                .offset(y: animationStates[6] ? 0 : -20)
                .blur(radius: animationStates[6] ? 0 : 4)

            // Google Sign Up Button
            Button(action: {}) {
                HStack {
                    Text("Sign up with Google")
                        .font(.system(size: 17))
                    Spacer()
                    Image(systemName: "g.circle.fill")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
                .cornerRadius(10)
            }
            .disabled(isLoading)
            .opacity(animationStates[7] ? 1 : 0)
            .offset(y: animationStates[7] ? 0 : -20)
            .blur(radius: animationStates[7] ? 0 : 4)

            // Apple Sign Up Button
            Button(action: {}) {
                HStack {
                    Text("Sign up with Apple")
                        .font(.system(size: 17))
                    Spacer()
                    Image(systemName: "apple.logo")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
                .cornerRadius(10)
            }
            .disabled(isLoading)
            .opacity(animationStates[8] ? 1 : 0)
            .offset(y: animationStates[8] ? 0 : -20)
            .blur(radius: animationStates[8] ? 0 : 4)
        }
        .padding(20)
        .background(
            LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white.opacity(0.1), .white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
        .onAppear {
            startSequenceAnimation()
        }
    }
    
    // MARK: - Animation Methods
    
    private func startSequenceAnimation() {
        for i in 0..<animationStates.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                withAnimation(.easeOut(duration: 0.6).delay(0)) {
                    animationStates[i] = true
                }
            }
        }
    }
    
    // MARK: - Validation Methods
    
    private func validateEmail(_ email: String) {
        if email.isEmpty {
            emailError = ""
            return
        }
        
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            emailError = "Please enter a valid email address"
        } else {
            emailError = ""
        }
    }
    
    private func validatePassword(_ password: String) {
        if password.isEmpty {
            passwordError = ""
            return
        }
        
        var errors: [String] = []
        
        if password.count < 8 {
            errors.append("at least 8 characters")
        }
        
        if !password.contains(where: { $0.isUppercase }) {
            errors.append("one uppercase letter")
        }
        
        if !password.contains(where: { $0.isLowercase }) {
            errors.append("one lowercase letter")
        }
        
        if !password.contains(where: { $0.isNumber }) {
            errors.append("one number")
        }
        
        if !errors.isEmpty {
            passwordError = "Password must contain " + errors.joined(separator: ", ")
        } else {
            passwordError = ""
        }
    }
    
    private var isFormValid: Bool {
        return !email.isEmpty && 
               !password.isEmpty && 
               emailError.isEmpty && 
               passwordError.isEmpty
    }
    
    private func handleSignUp() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isLoading = false
            // Handle sign up logic here
            print("Sign up attempted with email: \(email)")
        }
    }
}

#Preview {
    SignUpView()
        .preferredColorScheme(.dark)
        .background(Color.black)
}