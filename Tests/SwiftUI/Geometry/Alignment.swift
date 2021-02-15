package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test

class AlignmentTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // Alignment
        val orig_a = Alignment.center
        val data_a = json.encodeToString(Alignment.Serializer, orig_a)
        val json_a = json.decodeFromString(Alignment.Serializer, data_a)
        Assert.assertEquals(orig_a, json_a)
        Assert.assertEquals("\"center\"", data_a)

        // HorizontalAlignment
        val orig_ha = HorizontalAlignment.leading
        val data_ha = json.encodeToString(HorizontalAlignment.Serializer, orig_ha)
        val json_ha = json.decodeFromString(HorizontalAlignment.Serializer, data_ha)
        Assert.assertEquals(orig_ha, json_ha)
        Assert.assertEquals("\"leading\"", data_ha)

        // VerticalAlignment
        val orig_va = VerticalAlignment.top
        val data_va = json.encodeToString(VerticalAlignment.Serializer, orig_va)
        val json_va = json.decodeFromString(VerticalAlignment.Serializer, data_va)
        Assert.assertEquals(orig_va, json_va)
        Assert.assertEquals("\"top\"", data_va)
    }
}