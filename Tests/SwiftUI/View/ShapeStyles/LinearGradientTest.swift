package kotlinx.kotlinui

import android.graphics.Color as CGColor
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkStatic
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class LinearGradientTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }
        _Plane.mockColor()

        // LinearGradient
        val orig_lg = LinearGradient(Gradient(arrayOf(Color.red)), UnitPoint.center, UnitPoint.bottom)
        val data_lg = json.encodeToString(LinearGradient.Serializer, orig_lg)
        val json_lg = json.decodeFromString(LinearGradient.Serializer, data_lg)
        Assert.assertEquals(orig_lg, json_lg)
        Assert.assertEquals(
            """{
    "gradient": [
        {
            "color": {
                "color": "red"
            }
        }
    ],
    "startPoint": "center",
    "endPoint": "bottom"
}""".trimIndent(), data_lg
        )
    }
}