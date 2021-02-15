package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class CapsuleTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // Capsule
        val orig_c = Capsule()
        val data_c = json.encodeToString(Capsule.Serializer, orig_c)
        val json_c = json.decodeFromString(Capsule.Serializer, data_c)
        Assert.assertEquals(orig_c, json_c)
        Assert.assertEquals(
            """{
}""".trimIndent(), data_c
        )

        // Capsule._Inset
        val orig_c_i = Capsule().inset(1f) as ModifiedContent<Capsule, Capsule._Inset>
        val data_c_i = json.encodeToString(ModifiedContent.Serializer(), orig_c_i)
        val json_c_i = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_c_i)
        Assert.assertEquals(orig_c_i, json_c_i)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Capsule"
    },
    "modifier": {
        "type": ":Capsule._Inset",
        "amount": 1.0
    }
}""".trimIndent(), data_c_i
        )
    }
}