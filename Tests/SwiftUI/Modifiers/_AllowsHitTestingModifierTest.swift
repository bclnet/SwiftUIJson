package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _AllowsHitTestingModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // _AllowsHitTestingModifier
        val orig_ahtm = _AllowsHitTestingModifier(true)
        val data_ahtm = json.encodeToString(_AllowsHitTestingModifier.Serializer, orig_ahtm)
        val json_ahtm = json.decodeFromString(_AllowsHitTestingModifier.Serializer, data_ahtm)
        Assert.assertEquals(orig_ahtm, json_ahtm)
        Assert.assertEquals("""{
    "active": true
}""".trimIndent(), data_ahtm)
    }
}