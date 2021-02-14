package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _SizeShapeTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()
        _Plane.mockSize(10f, 10f)

        // _SizeShape
        val orig_ss = Circle().size(10f, 10f) as ModifiedContent<Circle, _SizedShape<Circle>>
        val data_ss = json.encodeToString(ModifiedContent.Serializer(), orig_ss)
//        val json_ss = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_ss)
//        Assert.assertEquals(orig_ss, json_ss)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Circle"
    },
    "modifier": {
        "type": ":_SizedShape",
        "shape": {
            "type": ":Circle"
        },
        "size": [
            10.0,
            10.0
        ]
    }
}""".trimIndent(), data_ss
        )
    }
}