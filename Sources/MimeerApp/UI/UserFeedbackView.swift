//
//  UserFeedbackView.swift
//  MimeerApp
//
//  Created by Caleb Friden on 10/1/23.
//

import SwiftUI

struct UserFeedbackView: View {
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Optional", text: $name)
                    #if os(iOS)
                        .textContentType(.name)
                    #endif
            }
            Section(
                header: Text("Email"),
                footer: Text(
                    "Provide your email if you are willing for the developer to reach out to you with questions about your report."
                )
            ) {
                TextField("Optional", text: $email)
                    #if os(iOS)
                        .textContentType(.emailAddress)
                    #endif
            }
            Section(
                header: Text("Comments"),
                footer: Text(
                    "Please be as detailed as possible and include steps to reproduce the issue if possible."
                )
            ) {
                TextEditor(text: $comments)
            }
        }
        #if os(macOS)
            .padding()
        #endif
        .alert(isPresented: $isThankYouAlertPresented) {
            Alert(
                title: Text("Thank You!"),
                message: Text(
                    "I know that was tedious, but I really appreciate you taking the time to submit feedback! Hearing directly from users is the best way for me to deliver a great experience."
                ),
                dismissButton: .default(
                    Text("Got it!"),
                    action: {
                        dismiss()
                    }))
        }
        .navigationTitle("Send Feedback")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                sendButton
            }
        }
    }

    // MARK: Private

    @MainActor
    private var sendButton: some View {
        Button("Send") {
            sendFeedback()
        }
        .disabled(isRequiredFieldEmpty)
    }

    @Environment(\.dismiss)
    private var dismiss

    @State
    private var comments: String = ""

    @State
    private var email: String = ""

    @State
    private var name: String = ""

    @State
    private var isThankYouAlertPresented = false

    private var isRequiredFieldEmpty: Bool { comments.isEmpty }

    @MainActor
    private func sendFeedback() {
        withAnimation {
            DiagnosticReporter.shared.captureUserFeedback(
                name: name, email: email, comments: comments)
            isThankYouAlertPresented = true
        }
    }
}

#Preview {
    UserFeedbackView()
}
