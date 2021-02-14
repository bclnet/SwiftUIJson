package kotlinx.kotlinui

import android.graphics.Matrix
import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class TransformedShapeTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // TransformedShape
        val orig_ts = Circle().transform(Matrix()) as ModifiedContent<Circle, TransformedShape<Circle>>
        val data_ts = json.encodeToString(ModifiedContent.Serializer(), orig_ts)
        val json_ts = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_ts)
        Assert.assertEquals(orig_ts, json_ts)
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
        "style": {
        }
    }
}""".trimIndent(), data_ts
        )
    }
}