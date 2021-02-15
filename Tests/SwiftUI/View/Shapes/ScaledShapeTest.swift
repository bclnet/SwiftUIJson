package kotlinx.kotlinui

import io.mockk.mockkStatic
import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ScaledShapeTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()
        _Plane.mockSize(10f, 10f)

        // ScaledShape
        val orig_ss = Circle().scale(10f, 10f) as ModifiedContent<Circle, ScaledShape<Circle>>
        val data_ss = json.encodeToString(ModifiedContent.Serializer(), orig_ss)
        val json_ss = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_ss)
        Assert.assertEquals(orig_ss, json_ss)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Circle"
    },
    "modifier": {
        "type": ":ScaledShape",
        "shape": {
            "type": ":Circle"
        },
        "scale": [
            10.0,
            10.0
        ],
        "anchor": "center"
    }
}""".trimIndent(), data_ss
        )
    }
}