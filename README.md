# SwiftUIJson

A Json representation of SwiftUI enabling runtime defined views

## Example

JsonPreview will provide json output with a before, and after representation.

```swift
import SwiftUI
import SwiftUIJson

struct SampleView: View {
    var body: some View {
        VStack {
            Text("Hello World")
        }
        .padding()
    }
}

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        JsonPreview {
            SampleView()
        }
    }
}
```

## References

The extension method `var` will let SwiftUIJson know this is intended to be a variable.

```swift
VStack {
    Text("Title Here".var(self))
}
```