package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _TrimmedShapeTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // _TrimmedShape
        val orig_ts = Circle().trim() as ModifiedContent<Circle, _TrimmedShape<Circle>>
        val data_ts = json.encodeToString(ModifiedContent.Serializer(), orig_ts)
        val json_ts = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_ts)
        Assert.assertEquals(orig_ts, json_ts)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Circle"
    },
    "modifier": {
        "type": ":_TrimmedShape",
        "shape": {
            "type": ":Circle"
        },
        "startFraction": 0.0,
        "endFraction": 1.0
    }
}""".trimIndent(), data_ts
        )
    }
}