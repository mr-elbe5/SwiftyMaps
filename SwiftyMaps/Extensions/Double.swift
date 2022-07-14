
import Foundation

extension Double {
    var toRadians : Double {
        var m = Measurement(value: self, unit: UnitAngle.degrees)
        m.convert(to: .radians)
        return m.value
    }
    var toDegrees : Double {
        var m = Measurement(value: self, unit: UnitAngle.radians)
        m.convert(to: .degrees)
        return m.value
    }
}
