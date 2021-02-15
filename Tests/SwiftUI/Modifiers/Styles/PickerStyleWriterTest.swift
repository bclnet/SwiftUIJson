@file: OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class PickerStyleWriterTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // PickerStyleWriter
        val orig_psw = PickerStyleWriter(DefaultPickerStyle())
        val data_psw = json.encodeToString(PickerStyleWriter.Serializer(), orig_psw)
        val json_psw = json.decodeFromString(PickerStyleWriter.Serializer<PickerStyle>(), data_psw)
        Assert.assertEquals(orig_psw, json_psw)
        Assert.assertEquals(
            """{
    "style": {
        "type": ":DefaultPickerStyle"
    }
}""".trimIndent(), data_psw
        )
    }
}