package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ShapeTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // CGLineCap
        val orig_cglc = CGLineCap.butt
        val data_cglc = json.encodeToString(CGLineCap.Serializer, orig_cglc)
        val json_cglc = json.decodeFromString(CGLineCap.Serializer, data_cglc)
        Assert.assertEquals(orig_cglc, json_cglc)
        Assert.assertEquals("\"butt\"", data_cglc)

        // CGLineJoin
        val orig_cglj = CGLineJoin.miter
        val data_cglj = json.encodeToString(CGLineJoin.Serializer, orig_cglj)
        val json_cglj = json.decodeFromString(CGLineJoin.Serializer, data_cglj)
        Assert.assertEquals(orig_cglj, json_cglj)
        Assert.assertEquals("\"miter\"", data_cglj)

        // FillStyle
        val orig_fs = FillStyle()
        val data_fs = json.encodeToString(FillStyle.Serializer, orig_fs)
        val json_fs = json.decodeFromString(FillStyle.Serializer, data_fs)
        Assert.assertEquals(orig_fs, json_fs)
        Assert.assertEquals(
            """{
}""".trimIndent(), data_fs
        )

        // FixedRoundedRect : NEED

        // RoundedCornerStyle
        val orig_rcs = RoundedCornerStyle.circular
        val data_rcs = json.encodeToString(RoundedCornerStyle.Serializer, orig_rcs)
        val json_rcs = json.decodeFromString(RoundedCornerStyle.Serializer, data_rcs)
        Assert.assertEquals(orig_rcs, json_rcs)
        Assert.assertEquals("\"circular\"", data_rcs)

        // StrokeStyle
        val orig_ss = StrokeStyle()
        val data_ss = json.encodeToString(StrokeStyle.Serializer, orig_ss)
        val json_ss = json.decodeFromString(StrokeStyle.Serializer, data_ss)
        Assert.assertEquals(orig_ss, json_ss)
        Assert.assertEquals(
            """{
}""".trimIndent(), data_ss
        )
    }
}