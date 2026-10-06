//
//  ContentView.swift
//  onboardingDemo
//
//  Created by Sachin Goswami on 19/09/26.
//

import SwiftUI

struct ContentView: View {
    @State private var finished = false

    var body: some View {
        if finished {
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.green)
                Text("You're all set!")
                    .font(.title.bold())
                Button("Replay onboarding") {
                    finished = false
                }
                .buttonStyle(.borderedProminent)
            }
        } else {
            ConcentricOnboarding(pages: OnboardingPage.bank) {
                withAnimation { finished = true }
            }
        }
    }
}

#Preview {
    ContentView()
}
