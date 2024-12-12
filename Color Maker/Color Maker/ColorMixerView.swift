import SwiftUI

// Cloud Shape Definition
struct PaintSplashShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        // Center arc
        path.addArc(center: CGPoint(x: width * 0.5, y: height * 0.4),
                    radius: width * 0.3, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)

        // Left arc
        path.addArc(center: CGPoint(x: width * 0.3, y: height * 0.5),
                    radius: width * 0.2, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)

        // Right arc
        path.addArc(center: CGPoint(x: width * 0.7, y: height * 0.5),
                    radius: width * 0.25, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)

        // Bottom-left arc
        path.addArc(center: CGPoint(x: width * 0.4, y: height * 0.7),
                    radius: width * 0.25, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)

        // Bottom-right arc
        path.addArc(center: CGPoint(x: width * 0.6, y: height * 0.7),
                    radius: width * 0.25, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)

        return path
    }
}

// Color Mixer View
struct ColorMixerView: View {
    @State private var redValue: Double = 1.0
    @State private var greenValue: Double = 1.0
    @State private var blueValue: Double = 1.0
    
    @State private var redEnabled: Bool = true
    @State private var greenEnabled: Bool = true
    @State private var blueEnabled: Bool = true
    
    // Backup values to restore on toggle back on
    @State private var redBackup: Double = 1.0
    @State private var greenBackup: Double = 1.0
    @State private var blueBackup: Double = 1.0
    
    // Dynamically calculated color based on RGB values
    private var currentColor: Color {
        Color(
            red: redEnabled ? redValue : 0,
            green: greenEnabled ? greenValue : 0,
            blue: blueEnabled ? blueValue : 0
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Color preview box
                ColorPreviewBox(color: currentColor)
                    .frame(height: geometry.size.height * 0.4)
                    .padding()
                
                // RGB Controls
                RGBControlSlider(
                    colorName: "Red", value: $redValue, enabled: $redEnabled, backup: $redBackup
                )
                RGBControlSlider(
                    colorName: "Green", value: $greenValue, enabled: $greenEnabled, backup: $greenBackup
                )
                RGBControlSlider(
                    colorName: "Blue", value: $blueValue, enabled: $blueEnabled, backup: $blueBackup
                )
                
                Spacer()
                
                // Reset Button
                Button(action: resetValues) {
                    Text("Reset")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding([.leading, .trailing])
                }
            }
        }
        .padding()
    }
    
    // Resets the sliders and switches to their default values
    func resetValues() {
        redValue = 1.0
        greenValue = 1.0
        blueValue = 1.0
        redEnabled = true
        greenEnabled = true
        blueEnabled = true
        redBackup = 1.0
        greenBackup = 1.0
        blueBackup = 1.0
    }
}

// Cloud Preview Box
struct ColorPreviewBox: View {
    var color: Color
    
    var body: some View {
        ZStack {
            PaintSplashShape()  // Using the cloud shape
                .fill(color)  // Filling the cloud shape with the current color
                .shadow(radius: 10)
            Text("Color Preview")
                .foregroundColor(.white)
                .bold()
        }
    }
}

// RGB Control Slider
struct RGBControlSlider: View {
    let colorName: String
    @Binding var value: Double
    @Binding var enabled: Bool
    @Binding var backup: Double
    
    var body: some View {
        VStack {
            HStack {
                Text("\(colorName) (\(Int(value * 255)))")
                Spacer()
                Toggle("", isOn: $enabled)
                    .onChange(of: enabled) { isOn in
                        if !isOn {
                            backup = value
                            value = 0
                        } else {
                            value = backup
                        }
                    }
                    .labelsHidden()
            }
            .padding([.leading, .trailing])
            
            Slider(value: $value, in: 0...1)
                .disabled(!enabled)
                .padding([.leading, .trailing])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ColorMixerView()
    }
}
