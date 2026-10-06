//
//  OnboardingIllustrations.swift
//  onboardingDemo
//
//  Created by Sachin Goswami on 19/09/26.
//

import SwiftUI

extension OnboardingPage {
    static let grapes: [OnboardingPage] = [
        OnboardingPage(
            title: "Eating grapes 101",
            step: "Step 1",
            message: "Break off a branch holding a few grapes and lay it on your plate.",
            background: Color(hex: 0xE88A87),
            accent: Color(hex: 0xFFE58F)
        ) {
            GrapeCluster(palette: [Color(hex: 0x8FD3B6), Color(hex: 0x6FBFA0), Color(hex: 0xA9E0CB)])
        },
        OnboardingPage(
            title: "Eating grapes 101",
            step: "Step 2",
            message: "Give them a good rinse under cool water to wash away any dirt.",
            background: Color(hex: 0x7C8CE8),
            accent: Color(hex: 0xFFD6E0)
        ) {
            WaterDrop()
        },
        OnboardingPage(
            title: "Eating grapes 101",
            step: "Step 3",
            message: "Pick one grape at a time and pop it into your mouth.",
            background: Color(hex: 0xF2B564),
            accent: Color(hex: 0xFFF6D6)
        ) {
            PlatedGrapes()
        },
        OnboardingPage(
            title: "Eating grapes 101",
            step: "Step 4",
            message: "Chew slowly, enjoy the sweetness, and repeat until the plate is clean.",
            background: Color(hex: 0x4FB3A6),
            accent: Color(hex: 0xFFE58F)
        ) {
            SparklingGrapes()
        },
    ]
}

private let faceInk = Color(red: 0.16, green: 0.2, blue: 0.22).opacity(0.7)

private struct Smile: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.minY + rect.height * 2)
        )
        return path
    }
}

private struct CuteFace: View {
    let size: CGFloat

    var body: some View {
        VStack(spacing: size * 0.07) {
            HStack(spacing: size * 0.3) {
                Circle().frame(width: size * 0.09, height: size * 0.09)
                Circle().frame(width: size * 0.09, height: size * 0.09)
            }
            .foregroundStyle(faceInk)
            Smile()
                .stroke(faceInk, style: StrokeStyle(lineWidth: size * 0.05, lineCap: .round))
                .frame(width: size * 0.2, height: size * 0.08)
        }
    }
}

private struct GrapeBall: View {
    let color: Color
    let diameter: CGFloat
    var showsFace = true

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: diameter, height: diameter)
            .overlay {
                Circle()
                    .fill(.white.opacity(0.25))
                    .frame(width: diameter * 0.22, height: diameter * 0.22)
                    .offset(x: -diameter * 0.2, y: -diameter * 0.22)
            }
            .overlay {
                if showsFace { CuteFace(size: diameter).offset(y: diameter * 0.04) }
            }
    }
}

private struct Stem: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addCurve(
            to: CGPoint(x: rect.width * 0.35, y: rect.height * 0.15),
            control1: CGPoint(x: rect.width * 0.55, y: rect.height * 0.6),
            control2: CGPoint(x: rect.width * 0.1, y: rect.height * 0.55)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.width * 0.75, y: rect.height * 0.2),
            control: CGPoint(x: rect.width * 0.55, y: -rect.height * 0.15)
        )
        return path
    }
}

struct GrapeCluster: View {
    let palette: [Color]
    var ballSize: CGFloat = 58

    private let layout: [(x: CGFloat, y: CGFloat, face: Bool)] = [
        (-50, -40, false), (0, -44, false), (50, -40, false),
        (-25, 4, true), (25, 4, true),
        (0, 48, true),
    ]

    var body: some View {
        ZStack {
            Stem()
                .stroke(Color(red: 0.55, green: 0.36, blue: 0.36), style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .frame(width: 60, height: 50)
                .offset(x: 6, y: -92)

            ForEach(layout.indices, id: \.self) { i in
                GrapeBall(color: palette[i % palette.count], diameter: ballSize, showsFace: layout[i].face)
                    .offset(x: layout[i].x, y: layout[i].y)
            }
        }
    }
}

private struct DropShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width, h = rect.height
        let r = w / 2
        let cy = h - r
        // magic number for approximating a circle with bezier curves
        let k = r * 0.5523
        var path = Path()
        path.move(to: CGPoint(x: r, y: 0))
        path.addCurve(to: CGPoint(x: w, y: cy),
                      control1: CGPoint(x: w * 0.55, y: h * 0.2),
                      control2: CGPoint(x: w, y: h * 0.45))
        path.addCurve(to: CGPoint(x: r, y: h),
                      control1: CGPoint(x: w, y: cy + k),
                      control2: CGPoint(x: r + k, y: h))
        path.addCurve(to: CGPoint(x: 0, y: cy),
                      control1: CGPoint(x: r - k, y: h),
                      control2: CGPoint(x: 0, y: cy + k))
        path.addCurve(to: CGPoint(x: r, y: 0),
                      control1: CGPoint(x: 0, y: h * 0.45),
                      control2: CGPoint(x: w * 0.45, y: h * 0.2))
        path.closeSubpath()
        return path
    }
}

struct WaterDrop: View {
    var body: some View {
        ZStack {
            DropShape()
                .fill(Color(hex: 0xEAF3FF))
                .frame(width: 120, height: 165)
                .overlay {
                    CuteFace(size: 120).offset(y: 34)
                }

            Circle().fill(.white.opacity(0.7)).frame(width: 16, height: 16).offset(x: -95, y: -30)
            Circle().fill(.white.opacity(0.55)).frame(width: 10, height: 10).offset(x: -78, y: 50)
            Circle().fill(.white.opacity(0.7)).frame(width: 18, height: 18).offset(x: 98, y: 10)
            Circle().fill(.white.opacity(0.55)).frame(width: 11, height: 11).offset(x: 82, y: -60)
        }
    }
}

struct PlatedGrapes: View {
    private let purple = Color(hex: 0x8E6BC9)

    var body: some View {
        ZStack {
            Ellipse()
                .fill(.white.opacity(0.9))
                .frame(width: 220, height: 56)
                .offset(y: 78)
            Ellipse()
                .fill(Color(hex: 0xFFF6E3))
                .frame(width: 150, height: 34)
                .offset(y: 78)

            GrapeBall(color: purple.opacity(0.85), diameter: 66, showsFace: false)
                .offset(x: -70, y: 42)
            GrapeBall(color: purple.opacity(0.85), diameter: 66, showsFace: false)
                .offset(x: 70, y: 42)
            GrapeBall(color: purple, diameter: 120)
                .offset(y: 8)

            Ellipse()
                .fill(Color(hex: 0x6FBF73))
                .frame(width: 46, height: 22)
                .rotationEffect(.degrees(-25))
                .offset(x: 16, y: -62)
        }
    }
}

struct SparklingGrapes: View {
    var body: some View {
        ZStack {
            GrapeCluster(palette: [Color(hex: 0x8E6BC9), Color(hex: 0xA283DA), Color(hex: 0x7A58B8)])
            Image(systemName: "sparkle")
                .font(.system(size: 34))
                .foregroundStyle(Color(hex: 0xFFE58F))
                .offset(x: -105, y: -70)
            Image(systemName: "sparkle")
                .font(.system(size: 22))
                .foregroundStyle(.white)
                .offset(x: 108, y: -40)
            Image(systemName: "sparkle")
                .font(.system(size: 28))
                .foregroundStyle(Color(hex: 0xFFE58F))
                .offset(x: 96, y: 62)
        }
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
