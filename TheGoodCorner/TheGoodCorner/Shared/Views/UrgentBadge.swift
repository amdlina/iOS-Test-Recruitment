import SwiftUI

struct UrgentBadge: View {
    var padH: Int
    var padV: Int
    var body: some View {
        Text("Urgent")
            .font(.caption2.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, CGFloat(padH))
            .padding(.vertical, CGFloat(padV))
            .background(Capsule().fill(Color.red))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .accessibilityLabel("Annonce urgente")
    }
}
