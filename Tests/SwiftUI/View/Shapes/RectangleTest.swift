package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class RectangleTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // Rectangle
        val orig_r = Rectangle()
        val data_r = json.encodeToString(Rectangle.Serializer, orig_r)
        val json_r = json.decodeFromString(Rectangle.Serializer, data_r)
        Assert.assertEquals(orig_r, json_r)
        Assert.assertEquals(
            """{
}""".trimIndent(), data_r
        )

        // Rectangle._Inset
        val orig_r_i = Rectangle().inset(1f) as ModifiedContent<Rectangle, Rectangle._Inset>
        val data_r_i = json.encodeToString(ModifiedContent.Serializer(), orig_r_i)
        val json_r_i = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_r_i)
        Assert.assertEquals(orig_r_i, json_r_i)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Rectangle"
    },
    "modifier": {
        "type": ":Rectangle._Inset",
        "amount": 1.0
    }
}""".trimIndent(), data_r_i
        )
    }
}