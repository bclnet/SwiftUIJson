package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class EllipseTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // Ellipse
        val orig_e = Ellipse()
        val data_e = json.encodeToString(Ellipse.Serializer, orig_e)
        val json_e = json.decodeFromString(Ellipse.Serializer, data_e)
        Assert.assertEquals(orig_e, json_e)
        Assert.assertEquals(
            """{
}""".trimIndent(), data_e
        )

        // Ellipse._Inset
        val orig_e_i = Ellipse().inset(1f) as ModifiedContent<Ellipse, Ellipse._Inset>
        val data_e_i = json.encodeToString(ModifiedContent.Serializer(), orig_e_i)
        val json_e_i = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_e_i)
        Assert.assertEquals(orig_e_i, json_e_i)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Ellipse"
    },
    "modifier": {
        "type": ":Ellipse._Inset",
        "amount": 1.0
    }
}""".trimIndent(), data_e_i
        )
    }
}