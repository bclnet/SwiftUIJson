package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _AppearanceActionModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }
        _Plane.mockActionManager()

        // _AppearanceActionModifier
        val orig_aam = _AppearanceActionModifier({}, {})
        val data_aam = json.encodeToString(_AppearanceActionModifier.Serializer, orig_aam)
        val json_aam = json.decodeFromString(_AppearanceActionModifier.Serializer, data_aam)
        Assert.assertEquals(orig_aam, json_aam)
        Assert.assertEquals(
            """{
    "appear": "#0",
    "disappear": "#1"
}""".trimIndent(), data_aam
        )
    }
}