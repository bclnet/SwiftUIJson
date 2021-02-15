package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ContainerRelativeShapeTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // ContainerRelativeShape
        val orig_crs = ContainerRelativeShape()
        val data_crs = json.encodeToString(ContainerRelativeShape.Serializer, orig_crs)
        val json_crs = json.decodeFromString(ContainerRelativeShape.Serializer, data_crs)
        Assert.assertEquals(orig_crs, json_crs)
        Assert.assertEquals(
            """{
}""".trimIndent(), data_crs
        )

        // ContainerRelativeShape.Inset
        val orig_crs_i = ContainerRelativeShape().inset(1f) as ModifiedContent<ContainerRelativeShape, ContainerRelativeShape._Inset>
        val data_crs_i = json.encodeToString(ModifiedContent.Serializer(), orig_crs_i)
        val json_crs_i = json.decodeFromString(ModifiedContent.Serializer<Any, ViewModifier>(), data_crs_i)
        Assert.assertEquals(orig_crs_i, json_crs_i)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":ContainerRelativeShape"
    },
    "modifier": {
        "type": ":ContainerRelativeShape._Inset",
        "amount": 1.0
    }
}""".trimIndent(), data_crs_i
        )
    }
}