package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test

class UnitPointTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // UnitPoint
        val orig_a = UnitPoint.center
        val data_a = json.encodeToString(UnitPoint.Serializer, orig_a)
        val json_a = json.decodeFromString(UnitPoint.Serializer, data_a)
        Assert.assertEquals(orig_a, json_a)
        Assert.assertEquals("\"center\"", data_a)
    }
}