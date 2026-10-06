//
//  BankOnboardingPages.swift
//  onboardingDemo
//
//  Created by Sachin Goswami on 19/09/26.
//

import SwiftUI

private enum Bank {
    static let blue = Color(hex: 0x005DAA)
    static let navy = Color(hex: 0x0A2E63)
    static let sky = Color(hex: 0x1B78D0)
    static let yellow = Color(hex: 0xFEDF01)
}

extension OnboardingPage {
    static let bank: [OnboardingPage] = [
        OnboardingPage(
            title: "All your accounts",
            step: "One simple view",
            message: "Check balances, track spending and see every transaction in one place.",
            background: Bank.blue,
            accent: Bank.yellow,
            onAccent: Bank.navy
        ) {
            AccountsIllustration()
        },
        OnboardingPage(
            title: "Send money fast",
            step: "Pay anyone, anytime",
            message: "Send money to friends and family with just an email address or mobile number.",
            background: Bank.navy,
            accent: Bank.yellow,
            onAccent: Bank.navy
        ) {
            SendMoneyIllustration()
        },
        OnboardingPage(
            title: "Deposit & pay bills",
            step: "No branch visit needed",
            message: "Snap a photo to deposit a cheque and pay your bills in a few taps.",
            background: Bank.sky,
            accent: Bank.yellow,
            onAccent: Bank.navy
        ) {
            DepositIllustration()
        },
        OnboardingPage(
            title: "Safe and secure",
            step: "Protected every step",
            message: "Sign in with Face ID and get instant alerts about activity on your accounts.",
            background: Bank.yellow,
            accent: Bank.navy,
            foreground: Bank.navy,
            onAccent: .white
        ) {
            SecurityIllustration()
        },
    ]
}

private struct AccountsIllustration: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Bank.yellow)
                .frame(width: 230, height: 145)
                .rotationEffect(.degrees(9))
                .offset(x: 14, y: 12)

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.35))
                .frame(width: 230, height: 145)
                .rotationEffect(.degrees(-7))
                .offset(x: -12, y: 4)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Chequing")
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 16))
                }
                Spacer()
                Text("$4,250.00")
                    .font(.system(size: 30, weight: .bold))
                Text("•••• 4821")
                    .font(.system(size: 13, weight: .medium))
                    .opacity(0.6)
                    .padding(.top, 2)
            }
            .foregroundStyle(Bank.navy)
            .padding(18)
            .frame(width: 236, height: 148)
            .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 12, y: 8)

            HStack(spacing: 4) {
                Image(systemName: "arrow.down.left")
                Text("$120.00")
            }
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Color(hex: 0x2FA36B), in: Capsule())
            .offset(x: 82, y: -84)
        }
    }
}

private struct SendArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.minY - rect.height)
        )
        return path
    }
}

private struct SendMoneyIllustration: View {
    var body: some View {
        ZStack {
            SendArc()
                .stroke(.white.opacity(0.5), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [2, 9]))
                .frame(width: 190, height: 80)
                .offset(y: -30)

            avatar("person.fill", tint: Bank.blue)
                .offset(x: -100, y: 18)
            avatar("person.fill", tint: Color(hex: 0x2FA36B))
                .offset(x: 100, y: 18)

            Circle()
                .fill(Bank.yellow)
                .frame(width: 58, height: 58)
                .overlay {
                    Text("$")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundStyle(Bank.navy)
                }
                .shadow(color: .black.opacity(0.2), radius: 8, y: 5)
                .offset(y: -62)

            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color(hex: 0x2FA36B))
                Text("Sent")
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(Bank.navy)
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background(.white, in: Capsule())
            .offset(y: 82)
        }
    }

    private func avatar(_ symbol: String, tint: Color) -> some View {
        Circle()
            .fill(.white)
            .frame(width: 76, height: 76)
            .overlay {
                Image(systemName: symbol)
                    .font(.system(size: 34))
                    .foregroundStyle(tint)
            }
            .shadow(color: .black.opacity(0.2), radius: 8, y: 5)
    }
}

private struct ViewfinderCorners: Shape {
    var length: CGFloat = 28

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for (cx, cy, dx, dy) in [
            (rect.minX, rect.minY, 1.0, 1.0),
            (rect.maxX, rect.minY, -1.0, 1.0),
            (rect.minX, rect.maxY, 1.0, -1.0),
            (rect.maxX, rect.maxY, -1.0, -1.0),
        ] as [(CGFloat, CGFloat, CGFloat, CGFloat)] {
            path.move(to: CGPoint(x: cx + dx * length, y: cy))
            path.addLine(to: CGPoint(x: cx, y: cy))
            path.addLine(to: CGPoint(x: cx, y: cy + dy * length))
        }
        return path
    }
}

private struct DepositIllustration: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    bar(width: 70)
                    Spacer()
                    Text("$250.00")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Bank.navy)
                }
                bar(width: 130)
                bar(width: 100)
                Spacer(minLength: 0)
                HStack {
                    bar(width: 60)
                    Spacer()
                    Image(systemName: "signature")
                        .font(.system(size: 22))
                        .foregroundStyle(Bank.blue)
                }
            }
            .padding(16)
            .frame(width: 230, height: 130)
            .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .rotationEffect(.degrees(-4))
            .shadow(color: .black.opacity(0.18), radius: 10, y: 6)

            ViewfinderCorners()
                .stroke(Bank.yellow, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .frame(width: 262, height: 160)

            Circle()
                .fill(Color(hex: 0x2FA36B))
                .frame(width: 52, height: 52)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                }
                .overlay(Circle().stroke(.white, lineWidth: 4))
                .offset(x: 108, y: 78)
        }
    }

    private func bar(width: CGFloat) -> some View {
        Capsule()
            .fill(Bank.navy.opacity(0.14))
            .frame(width: width, height: 8)
    }
}

private struct SecurityIllustration: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.55))
                .frame(width: 220, height: 220)

            Image(systemName: "shield.fill")
                .font(.system(size: 150))
                .foregroundStyle(Bank.navy)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundStyle(Bank.yellow)
                        .offset(y: -4)
                }

            badge("faceid").offset(x: -104, y: -62)
            badge("bell.badge.fill").offset(x: 108, y: 44)
            badge("lock.fill").offset(x: -84, y: 84)
        }
    }

    private func badge(_ symbol: String) -> some View {
        Circle()
            .fill(.white)
            .frame(width: 56, height: 56)
            .overlay {
                Image(systemName: symbol)
                    .font(.system(size: 24))
                    .foregroundStyle(Bank.blue)
            }
            .shadow(color: .black.opacity(0.15), radius: 8, y: 5)
    }
}
