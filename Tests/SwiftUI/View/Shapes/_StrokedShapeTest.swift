package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _StrokedShapeTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // _StrokedShape
        val orig_ss = Circle().stroke(2f) as ModifiedContent<Circle, _StrokedShape<Circle>>
        val data_ss = json.encodeToString(ModifiedContent.Serializer(), orig_ss)
        val json_ss = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_ss)
        Assert.assertEquals(orig_ss, json_ss)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Circle"
    },
    "modifier": {
        "type": ":_StrokedShape",
        "shape": {
            "type": ":Circle"
        },
        "style": {
            "lineWidth": 2.0
        }
    }
}""".trimIndent(), data_ss
        )
    }
}