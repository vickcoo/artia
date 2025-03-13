import SwiftUI

struct MissionTypeStats: View {
    let missions: [Mission]

    private var mainCount: Int {
        missions.filter { $0.type == .main }.count
    }

    private var sideCount: Int {
        missions.filter { $0.type == .side }.count
    }

    private var repeatCount: Int {
        missions.filter { $0.type == .repeat }.count
    }

    var body: some View {
        HStack(spacing: 16) {
            StatBox(type: .main, count: mainCount)
            StatBox(type: .side, count: sideCount)
            StatBox(type: .repeat, count: repeatCount)
        }
        .padding()
    }
}

private struct StatBox: View {
    let type: MissionType
    let count: Int

    var body: some View {
        VStack {
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text(type.text)
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(type.color))
        )
    }
}

#Preview {
    MissionTypeStats(missions: MockData.tasks)
        .padding()
}
