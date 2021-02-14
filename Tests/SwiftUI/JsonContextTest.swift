@file:OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import kotlin.reflect.typeOf

class JsonContextTest {
    @Test
    fun serialize_slot() {
        val json = Json { prettyPrint = true }
        val orig_st = JsonContext.Slot(typeOf<String>(), "Test")
        val data_st = json.encodeToString(JsonContext.SlotSerializer, orig_st)
        val json_st = json.decodeFromString(JsonContext.SlotSerializer, data_st)
        Assert.assertEquals(orig_st, json_st)
    }

    @Test
    fun serialize_context() {
        val json = Json { prettyPrint = true }

        val orig_s0c0 = JsonContext()
        val data_s0c0 = json.encodeToString(JsonContextSerializer, orig_s0c0)
        val json_s0c0 = json.decodeFromString(JsonContextSerializer, data_s0c0)
        Assert.assertEquals(orig_s0c0, json_s0c0)

        val orig_s2c0 = JsonContext()
        with(orig_s2c0) {
            let("String")
            let(1)
        }
        val data_s2c0 = json.encodeToString(JsonContextSerializer, orig_s2c0)
        val json_s2c0 = json.decodeFromString(JsonContextSerializer, data_s2c0)
        Assert.assertEquals(orig_s2c0, json_s2c0)

        val orig_s0c1 = JsonContext()
        with(orig_s0c1) {
            val newContext = JsonContext()
            newContext.let("Test")
            contexts["SomeContext"] = newContext
        }
        val data_s0c1 = json.encodeToString(JsonContextSerializer, orig_s0c1)
        val json_s0c1 = json.decodeFromString(JsonContextSerializer, data_s0c1)
        Assert.assertEquals(orig_s0c1, json_s0c1)

        val orig_s1c1 = JsonContext()
        with(orig_s1c1) {
            let("String")
            val newContext = JsonContext()
            contexts["SomeContext"] = newContext
        }
        val data_s1c1 = json.encodeToString(JsonContextSerializer, orig_s1c1)
        val json_s1c1 = json.decodeFromString(JsonContextSerializer, data_s1c1)
        Assert.assertEquals(orig_s1c1, json_s1c1)
    }
}