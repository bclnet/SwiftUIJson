package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test

class AxisTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // Axis
        val orig_a = Axis.horizontal
        val data_a = json.encodeToString(Axis.Serializer, orig_a)
        val json_a = json.decodeFromString(Axis.Serializer, data_a)
        Assert.assertEquals(orig_a, json_a)
        Assert.assertEquals("\"horizontal\"", data_a)

        // Axis.Set
        val orig_as = Axis.Set.horizontal
        val data_as = json.encodeToString(Axis.SetSerializer, orig_as)
        val json_as = json.decodeFromString(Axis.SetSerializer, data_as)
        Assert.assertEquals(orig_as, json_as)
        Assert.assertEquals(
            """[
    "horizontal"
]""".trimIndent(), data_as
        )
    }
}