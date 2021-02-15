package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class PathTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

//        // Path
//        val orig_p = Path()
//        val data_p = json.encodeToString(Path.Serializer, orig_p)
//        val json_p = json.decodeFromString(Path.Serializer, data_p)
//        Assert.assertEquals(orig_p, json_p)
//        Assert.assertEquals(
//            """{
//    "type": ":Circle"
//}""".trimIndent(), data_p
//        )
    }
}