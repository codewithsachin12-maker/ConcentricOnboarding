//
//  ConcentricOnboarding.swift
//  onboardingDemo
//
//  Created by Sachin Goswami on 19/09/26.
//

import SwiftUI

struct ConcentricOnboarding: View {
    let pages: [OnboardingPage]
    var onFinish: () -> Void = {}

    @State private var index: Int
    // 0 = current page showing, 1 = next page fully expanded over it
    @State private var reveal: CGFloat = 0
    @State private var isAnimating = false

    init(pages: [OnboardingPage], startIndex: Int = 0, onFinish: @escaping () -> Void = {}) {
        self.pages = pages
        self.onFinish = onFinish
        _index = State(initialValue: min(max(startIndex, 0), pages.count - 1))
    }

    private let buttonSize: CGFloat = 64
    private let buttonBottomPadding: CGFloat = 56
    private let duration: Double = 3.0

    var body: some View {
        GeometryReader { outer in
            let insets = outer.safeAreaInsets
            GeometryReader { proxy in
                let size = proxy.size
                // the circle grows out of the next button
                let center = CGPoint(
                    x: size.width / 2,
                    y: size.height - insets.bottom - buttonBottomPadding - buttonSize / 2
                )
                // distance to the farthest corner, so the circle covers the whole screen
                let maxRadius = hypot(
                    max(center.x, size.width - center.x),
                    max(center.y, size.height - center.y)
                )
                let slide = size.width * 0.3
                let reservedBottom = insets.bottom + buttonBottomPadding + buttonSize + 24

                ZStack {
                    layer(pages[index], topInset: insets.top, bottomInset: reservedBottom,
                          offset: -reveal * slide, opacity: 1 - reveal)

                    if index + 1 < pages.count {
                        layer(pages[index + 1], topInset: insets.top, bottomInset: reservedBottom,
                              offset: (1 - reveal) * slide, opacity: reveal)
                            .mask {
                                Circle()
                                    .frame(width: 2 * maxRadius * reveal, height: 2 * maxRadius * reveal)
                                    .position(center)
                            }
                    }

                    nextButton
                        .position(center)
                }
                .frame(width: size.width, height: size.height)
            }
            .ignoresSafeArea()
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: index)
    }

    // only the content slides and fades, the background stays put
    private func layer(
        _ page: OnboardingPage,
        topInset: CGFloat,
        bottomInset: CGFloat,
        offset: CGFloat,
        opacity: Double
    ) -> some View {
        ZStack {
            page.background
            PageContent(page: page)
                .padding(.top, topInset)
                .padding(.bottom, bottomInset)
                .offset(x: offset)
                .opacity(opacity)
        }
    }

    private var isLastPage: Bool { index == pages.count - 1 }

    // button already uses the next page's colors while the circle is growing
    private var shownIndex: Int { min(index + (isAnimating ? 1 : 0), pages.count - 1) }

    private var progress: CGFloat {
        (CGFloat(index) + reveal + 1) / CGFloat(pages.count)
    }

    private var nextButton: some View {
        Button(action: advance) {
            ZStack {
                Circle()
                    .stroke(pages[shownIndex].foreground.opacity(0.3), lineWidth: 3)
                    .frame(width: buttonSize + 20, height: buttonSize + 20)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(pages[shownIndex].foreground, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: buttonSize + 20, height: buttonSize + 20)

                Circle()
                    .fill(pages[shownIndex].accent)
                    .frame(width: buttonSize, height: buttonSize)
                Image(systemName: shownIndex == pages.count - 1 ? "checkmark" : "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(pages[shownIndex].onAccent)
                    .contentTransition(.symbolEffect(.replace))
            }
            .contentShape(Circle())
        }
        .buttonStyle(PressScaleStyle())
        .animation(.easeInOut(duration: 0.5), value: isAnimating)
        .accessibilityLabel(isLastPage ? "Finish" : "Next")
    }

    private func advance() {
        guard !isAnimating else { return }
        guard index + 1 < pages.count else {
            onFinish()
            return
        }

        isAnimating = true
        withAnimation(.easeInOut(duration: duration)) {
            reveal = 1
        } completion: {
            // the next page now looks exactly like the current one at reveal 0,
            // so swap them without animating
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                index += 1
                reveal = 0
                isAnimating = false
            }
        }
    }
}

private struct PageContent: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            Text(page.title)
                .font(.system(size: 34, weight: .bold))
            Spacer(minLength: 0)
            page.illustration
                .frame(height: 240)
            Spacer(minLength: 0)
            VStack(spacing: 8) {
                Text(page.step)
                    .font(.system(size: 22, weight: .semibold))
                Text(page.message)
                    .font(.system(size: 16, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 44)
            Spacer(minLength: 0)
        }
        .foregroundStyle(page.foreground)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct PressScaleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct OnboardingPage: Identifiable {
    let id = UUID()
    var title: String
    var step: String
    var message: String
    var background: Color
    var accent: Color
    var foreground: Color
    var onAccent: Color
    var illustration: AnyView

    init<Illustration: View>(
        title: String,
        step: String,
        message: String,
        background: Color,
        accent: Color,
        foreground: Color = .white,
        onAccent: Color = Color(white: 0.2).opacity(0.55),
        @ViewBuilder illustration: () -> Illustration
    ) {
        self.title = title
        self.step = step
        self.message = message
        self.background = background
        self.accent = accent
        self.foreground = foreground
        self.onAccent = onAccent
        self.illustration = AnyView(illustration())
    }
}

#Preview("Bank onboarding") {
    ConcentricOnboarding(pages: OnboardingPage.bank)
}

#Preview("Grapes onboarding") {
    ConcentricOnboarding(pages: OnboardingPage.grapes)
}
