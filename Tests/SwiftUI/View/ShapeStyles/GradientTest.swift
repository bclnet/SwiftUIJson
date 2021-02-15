package kotlinx.kotlinui

import android.graphics.Color as CGColor
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkStatic
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class GradientTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }
        _Plane.mockColor()

        // Gradient
        val orig_g = Gradient(arrayOf(Color.red, Color.blue))
        val data_g = json.encodeToString(Gradient.Serializer, orig_g)
        val json_g = json.decodeFromString(Gradient.Serializer, data_g)
        Assert.assertEquals(orig_g, json_g)
        Assert.assertEquals(
            """[
    {
        "color": {
            "color": "red"
        }
    },
    {
        "color": {
            "color": "blue"
        }
    }
]""".trimIndent(), data_g
        )
    }
}