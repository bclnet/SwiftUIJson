@file: OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class DatePickerStyleModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // DatePickerStyleModifier
        val orig_dpsm = DatePickerStyleModifier(DefaultDatePickerStyle())
        val data_dpsm = json.encodeToString(DatePickerStyleModifier.Serializer(), orig_dpsm)
        val json_dpsm = json.decodeFromString(DatePickerStyleModifier.Serializer<DatePickerStyle>(), data_dpsm)
        Assert.assertEquals(orig_dpsm, json_dpsm)
        Assert.assertEquals(
            """{
    "style": {
        "type": ":DefaultDatePickerStyle"
    }
}""".trimIndent(), data_dpsm
        )
    }
}