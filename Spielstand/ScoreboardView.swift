import SwiftUI

struct ScoreboardView: View {
    @State private var model: ScoreModel = {
        let model = ScoreModel()
        #if DEBUG
        // Launch with `-screenshotDemo` to show a game in progress (App Store screenshots).
        if CommandLine.arguments.contains("-screenshotDemo") {
            model.homeName = "Tigers"
            model.guestName = "Eagles"
            for p in [3, 2, 2, 3, 2, 1, 2, 3, 2, 2, 2, 3, 2, 2, 1, 2, 3, 2, 2, 3, 2, 2, 2, 3, 2] { model.add(p, to: .home) }
            for p in [2, 2, 3, 2, 1, 1, 2, 3, 2, 2, 2, 3, 2, 3, 2, 2, 1, 2, 3, 2, 2, 2, 2, 3] { model.add(p, to: .guest) }
            model.add(3, to: .home)
        }
        #endif
        return model
    }()

    private let homeColor = Color(red: 0.06, green: 0.43, blue: 0.34)   // teal
    private let guestColor = Color(red: 0.60, green: 0.24, blue: 0.11)  // coral

    var body: some View {
        HStack(spacing: 0) {
            TeamPanel(
                name: $model.homeName,
                score: model.homeScore,
                color: homeColor,
                onAdd: { model.add($0, to: .home) }
            )

            Divider()

            VStack(spacing: 8) {
                Button {
                    model.undo()
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.title2.weight(.semibold))
                        .frame(width: 64, height: 64)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
                .disabled(model.history.isEmpty)
                .accessibilityLabel("Undo last score")

                Text("Undo")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(model.lastActionLabel ?? " ")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100)

            Divider()

            TeamPanel(
                name: $model.guestName,
                score: model.guestScore,
                color: guestColor,
                onAdd: { model.add($0, to: .guest) }
            )
        }
        .padding(.vertical, 12)
    }
}

private struct TeamPanel: View {
    @Binding var name: String
    let score: Int
    let color: Color
    let onAdd: (Int) -> Void

    var body: some View {
        VStack(spacing: 8) {
            TextField("Team name", text: $name)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(color)
                .submitLabel(.done)
                .padding(.horizontal, 24)

            Text("\(score)")
                .font(.system(size: 140, weight: .bold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.4)
                .lineLimit(1)
                .contentTransition(.numericText())
                .animation(.snappy, value: score)

            HStack(spacing: 12) {
                ForEach([1, 2, 3], id: \.self) { points in
                    Button {
                        onAdd(points)
                    } label: {
                        Text("+\(points)")
                            .font(.title2.weight(.bold))
                            .frame(width: 72, height: 52)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(color)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview(traits: .landscapeLeft) {
    ScoreboardView()
}
