package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class CircleTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // Circle
        val orig_c = Circle()
        val data_c = json.encodeToString(Circle.Serializer, orig_c)
        val json_c = json.decodeFromString(Circle.Serializer, data_c)
        Assert.assertEquals(orig_c, json_c)
        Assert.assertEquals(
            """{
}""".trimIndent(), data_c
        )

        // Circle._Inset
        val orig_c_i = Circle().inset(1f) as ModifiedContent<Circle, Circle._Inset>
        val data_c_i = json.encodeToString(ModifiedContent.Serializer(), orig_c_i)
        val json_c_i = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_c_i)
        Assert.assertEquals(orig_c_i, json_c_i)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Circle"
    },
    "modifier": {
        "type": ":Circle._Inset",
        "amount": 1.0
    }
}""".trimIndent(), data_c_i
        )
    }
}