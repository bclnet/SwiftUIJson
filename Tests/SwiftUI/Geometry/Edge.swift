package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import java.util.*

class EdgeTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // Edge
        val orig_e = Edge.top
        val data_e = json.encodeToString(Edge.Serializer, orig_e)
        val json_e = json.decodeFromString(Edge.Serializer, data_e)
        Assert.assertEquals(orig_e, json_e)
        Assert.assertEquals("\"top\"", data_e)

        // Edge.Set
        val orig_es_a = Edge.Set.top
        val data_es_a = json.encodeToString(Edge.SetSerializer, orig_es_a)
        val json_es_a = json.decodeFromString(Edge.SetSerializer, data_es_a)
        Assert.assertEquals(orig_es_a, json_es_a)
        Assert.assertEquals(
            """[
    "top"
]""".trimIndent(), data_es_a
        )
        val orig_es_b = EnumSet.of(Edge.top, Edge.bottom)
        val data_es_b = json.encodeToString(Edge.SetSerializer, orig_es_b)
        val json_es_b = json.decodeFromString(Edge.SetSerializer, data_es_b)
        Assert.assertEquals(orig_es_b, json_es_b)
        Assert.assertEquals(
            """[
    "top",
    "bottom"
]""".trimIndent(), data_es_b
        )
        val orig_es_c = Edge.Set.horizontal
        val data_es_c = json.encodeToString(Edge.SetSerializer, orig_es_c)
        val json_es_c = json.decodeFromString(Edge.SetSerializer, data_es_c)
        Assert.assertEquals(orig_es_c, json_es_c)
        Assert.assertEquals(
            """[
    "leading",
    "trailing"
]""".trimIndent(), data_es_c
        )

        // EdgeInsets
        val orig_ei = EdgeInsets(top = 1f, bottom = 1f)
        val data_ei = json.encodeToString(EdgeInsets.Serializer, orig_ei)
        val json_ei = json.decodeFromString(EdgeInsets.Serializer, data_ei)
        Assert.assertEquals(orig_ei, json_ei)
        Assert.assertEquals(
            """{
    "top": 1.0,
    "bottom": 1.0
}""".trimIndent(), data_ei
        )
    }
}