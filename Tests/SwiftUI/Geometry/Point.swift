package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test

class PointTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // Point
        val orig_p = Point(1, 2)
        val data_p = json.encodeToString(Point.Serializer, orig_p)
        val json_p = json.decodeFromString(Point.Serializer, data_p)
        Assert.assertEquals(orig_p, json_p)
        Assert.assertEquals(
            """[
    1,
    2
]""".trimIndent(), data_p
        )
    }
}