//
//  FeedbackView.swift
//  CaRent
//
//  Created by Jasdeep Singh on 2024-06-04.
//

import SwiftUI

struct FeedbackView: View {
    @State private var feedbackText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Provide Feedback")
                .bold()
            
            TextEditor(text: $feedbackText)
                .frame(height: 200)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            
            Button(action: {
                // Handle feedback submission
                submitFeedback()
            }) {
                Text("Submit Feedback")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func submitFeedback() {
        // Implement feedback submission logic here
        print("Feedback submitted: \(feedbackText)")
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
