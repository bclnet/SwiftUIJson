package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import kotlinx.serialization.modules.SerializersModule
import kotlinx.serialization.modules.contextual
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class SampleView : View {
    override val body: View
        get() =
            VStack {
                Text("Hello World")
            }
                .padding()
}

object SampleView_Previews : PreviewProvider {
    override val previews: View
        get() =
            JsonPreview {
                SampleView()
            }
}

class JsonUITest {
    @Test
    fun serialize_jsonui() {
        val context = JsonContext()
        context.let("Test")

        val json = Json {
            serializersModule = SerializersModule { contextual(JsonUISerializer.UserInfoJsonContext(context)) }
            prettyPrint = true
        }

        val orig_s0 = JsonUI<Text>(Text("Verbatim"))
        val data_s0 = json.encodeToString(JsonUISerializer, orig_s0)
        val json_s0 = json.decodeFromString(JsonUISerializer, data_s0)
        Assert.assertEquals(orig_s0, json_s0)

//        val orig_c0 = JsonUI(VStack {
//            get(
//                Text("Verbatim"),
//                Text("Verbatim")
//            )
//        })
//        val data_c0 = json.encodeToString(JsonUISerializer, orig_c0)
//        val json_c0 = json.decodeFromString(JsonUISerializer, data_c0)
//        Assert.assertEquals(orig_c0, json_c0)
    }

    @Test
    fun test_complex() {
        assertEquals(4, 2 + 2)
    }
}