package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _AlignmentWritingModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // _AlignmentWritingModifier
        val orig_awm = _AlignmentWritingModifier(true)
        val data_awm = json.encodeToString(_AlignmentWritingModifier.Serializer, orig_awm)
        val json_awm = json.decodeFromString(_AlignmentWritingModifier.Serializer, data_awm)
        Assert.assertEquals(orig_awm, json_awm)
        Assert.assertEquals(
            """{
    "active": true
}""".trimIndent(), data_awm
        )
    }
}