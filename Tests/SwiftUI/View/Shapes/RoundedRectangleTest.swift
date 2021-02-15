package kotlinx.kotlinui

import android.util.SizeF
import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class RoundedRectangleTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()
        _Plane.mockSize(1f, 1f)

        // RoundedRectangle
        val orig_rr = RoundedRectangle(SizeF(1f, 1f))
        val data_rr = json.encodeToString(RoundedRectangle.Serializer, orig_rr)
        val json_rr = json.decodeFromString(RoundedRectangle.Serializer, data_rr)
        Assert.assertEquals(orig_rr, json_rr)
        Assert.assertEquals(
            """{
    "cornerRadius": 1.0
}""".trimIndent(), data_rr
        )

        // RoundedRectangle._Inset
        val orig_rr_i = RoundedRectangle(SizeF(1f, 1f)).inset(1f) as ModifiedContent<RoundedRectangle, RoundedRectangle._Inset>
        val data_rr_i = json.encodeToString(ModifiedContent.Serializer(), orig_rr_i)
        val json_rr_i = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_rr_i)
        Assert.assertEquals(orig_rr_i, json_rr_i)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":RoundedRectangle",
        "cornerRadius": 1.0
    },
    "modifier": {
        "type": ":RoundedRectangle._Inset",
        "base": {
            "cornerRadius": 1.0
        },
        "amount": 1.0
    }
}""".trimIndent(), data_rr_i
        )
    }
}