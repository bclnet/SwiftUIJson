package kotlinx.kotlinui

import android.graphics.ColorSpace
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkStatic
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*
import android.graphics.Color as CGColor

class ColorTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }
        _Plane.mockColor()

        // __NSCFType
        val orig_s_a = Color.red
        val data_s_a = json.encodeToString(serializer(), orig_s_a)
        val json_s_a = json.decodeFromString(serializer<Color>(), data_s_a)
        Assert.assertEquals(orig_s_a, json_s_a)
        Assert.assertEquals("""{
    "color": "red"
}""".trimIndent(), data_s_a)
        val orig_s_b = Color(_Plane.makeCGColor(10f, 10f, 10f))
        val data_s_b = json.encodeToString(serializer(), orig_s_b)
        val json_s_b = json.decodeFromString(serializer<Color>(), data_s_b)
        //Assert.assertEquals(orig_s_b, json_s_b)
        Assert.assertEquals(
            """{
    "color": "system",
    "value": {
        "colorSpace": "SRGB",
        "components": [
            10.0,
            10.0,
            10.0
        ]
    }
}""".trimIndent(), data_s_b
        )

        // _Resolved
        val orig_r = Color(Color.RGBColorSpace.sRGB, 1.0, 2.0, 3.0)
        val data_r = json.encodeToString(serializer(), orig_r)
        val json_r = json.decodeFromString(serializer<Color>(), data_r)
        Assert.assertEquals(orig_r, json_r)
        Assert.assertEquals(
            """{
    "color": "resolved",
    "red": 1.0,
    "green": 2.0,
    "blue": 3.0,
    "opacity": 1.0
}""".trimIndent(), data_r
        )

        // DisplayP3
        val orig_dp3 = Color(Color.RGBColorSpace.displayP3, 4.0, 5.0, 6.0)
        val data_dp3 = json.encodeToString(serializer(), orig_dp3)
        val json_dp3 = json.decodeFromString(serializer<Color>(), data_dp3)
        Assert.assertEquals(orig_dp3, json_dp3)
        Assert.assertEquals(
            """{
    "color": "displayP3",
    "red": 4.0,
    "green": 5.0,
    "blue": 6.0,
    "opacity": 1.0
}""".trimIndent(), data_dp3
        )

        // NamedColor
        val orig_nc = Color("name")
        val data_nc = json.encodeToString(serializer(), orig_nc)
        val json_nc = json.decodeFromString(serializer<Color>(), data_nc)
        Assert.assertEquals(orig_nc, json_nc)
        Assert.assertEquals(
            """{
    "color": "named",
    "name": "name"
}""".trimIndent(), data_nc
        )

//        // PlatformColor
//        val orig_pc = Color("platform")
//        val data_pc = json.encodeToString(serializer(), orig_pc)
//        val json_pc = json.decodeFromString(serializer<Color>(), data_pc)
//        Assert.assertEquals(orig_pc, json_pc)
//        Assert.assertEquals("\"gray\"", data_pc)

        // OpacityColor
        val orig_oc = Color.red.opacity(.5)
        val data_oc = json.encodeToString(serializer(), orig_oc)
        val json_oc = json.decodeFromString(serializer<Color>(), data_oc)
        Assert.assertEquals(orig_oc, json_oc)
        Assert.assertEquals(
            """{
    "color": "opacity",
    "base": {
        "color": "red"
    },
    "opacity": 0.5
}""".trimIndent(), data_oc
        )
    }
}