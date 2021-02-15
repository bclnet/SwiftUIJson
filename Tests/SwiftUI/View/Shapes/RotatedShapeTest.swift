package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class RotatedShapeTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // RotatedShape
        val orig_rs = Circle().rotation(Angle()) as ModifiedContent<Circle, RotatedShape<Circle>>
        val data_rs = json.encodeToString(ModifiedContent.Serializer(), orig_rs)
        val json_rs = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_rs)
        Assert.assertEquals(orig_rs, json_rs)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Circle"
    },
    "modifier": {
        "type": ":RotatedShape",
        "shape": {
            "type": ":Circle"
        },
        "angle": 0.0,
        "anchor": "center"
    }
}""".trimIndent(), data_rs
        )
    }
}