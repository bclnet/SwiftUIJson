package kotlinx.kotlinui

import android.util.SizeF
import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class OffsetShapeTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()
        _Plane.mockSize(10f, 10f)

        // OffsetShape
        val orig_os = Circle().offset(SizeF(10f, 10f)) as ModifiedContent<Circle, OffsetShape<Circle>>
        val data_os = json.encodeToString(ModifiedContent.Serializer(), orig_os)
        val json_os = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_os)
        Assert.assertEquals(orig_os, json_os)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Circle"
    },
    "modifier": {
        "type": ":OffsetShape",
        "shape": {
            "type": ":Circle"
        },
        "offset": [
            10.0,
            10.0
        ]
    }
}""".trimIndent(), data_os
        )

        // OffsetShape.Inset : NEED
    }
}