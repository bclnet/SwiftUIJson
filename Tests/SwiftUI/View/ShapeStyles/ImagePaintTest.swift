package kotlinx.kotlinui

import android.graphics.Color as CGColor
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkStatic
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ImagePaintTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }
        _Plane.mockColor()

        // AngularGradient
        val orig_ag = AngularGradient(Gradient(arrayOf(Color.red)), UnitPoint.center, Angle(1.0), Angle(2.0))
        val data_ag = json.encodeToString(AngularGradient.Serializer, orig_ag)
        val json_ag = json.decodeFromString(AngularGradient.Serializer, data_ag)
        Assert.assertEquals(orig_ag, json_ag)
        Assert.assertEquals(
            """{
    "gradient": [
        {
            "color": {
                "color": "red"
            }
        }
    ],
    "center": "center",
    "startAngle": 1.0,
    "endAngle": 2.0
}""".trimIndent(), data_ag
        )
    }
}