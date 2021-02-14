package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _FilledShapeTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // _FilledShape
        val orig_fs = Circle().fill() as ModifiedContent<Circle, _FilledShape<Circle>>
        val data_fs = json.encodeToString(ModifiedContent.Serializer(), orig_fs)
        val json_fs = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_fs)
        Assert.assertEquals(orig_fs, json_fs)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Circle"
    },
    "modifier": {
        "type": ":_FilledShape",
        "shape": {
            "type": ":Circle"
        },
        "style": {
        }
    }
}""".trimIndent(), data_fs
        )
    }
}