package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test

class AngleTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // Angle
        val orig_a = Angle(45.0)
        val data_a = json.encodeToString(Angle.Serializer, orig_a)
        val json_a = json.decodeFromString(Angle.Serializer, data_a)
        Assert.assertEquals(orig_a, json_a)
        Assert.assertEquals("45.0", data_a)
    }
}