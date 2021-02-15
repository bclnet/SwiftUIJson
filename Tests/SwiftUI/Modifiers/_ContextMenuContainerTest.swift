package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _ContextMenuContainerTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // _ContextMenuContainer
//        val orig_cmc = _ContextMenuContainer("id")
//        val data_cmc = json.encodeToString(_ContextMenuContainer.Serializer, orig_cmc)
//        val json_cmc = json.decodeFromString(_ContextMenuContainer.Serializer, data_cmc)
//        Assert.assertEquals(orig_cmc, json_cmc)
//        Assert.assertEquals("""
//
//        """.trimIndent(), data_cmc)
    }
}