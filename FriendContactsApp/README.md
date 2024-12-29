# How to Create a View for Dual Purpose of Adding/Editing Entries

![SwiftUI Logo](https://developer.apple.com/news/images/og/swiftui-og.png)

> [!TIP]
> Use the acronym **`HCVDPAEE`** to navigate within the source code.

Using the same view to add and edit entries makes your code much shorter and, therefore, much easier to maintain. This is a pretty challenging feat for a beginner to accomplish because you would have to think thoroughly about the behavior that you would implement. This guide is just one of many possible solutions to achieve this, and I doubt that this implementation is the best solution out there.
- Create a view that can retrieve the value from its parent view.
-  Supply empty values as a way of adding entries; supply existing values as a way of editing entries.
-  Because the data for the new entries is empty, disable the insertion of new entries if the fields are not fully supplied by the user.

One caveat of this is that empty values are always created but are immediately deleted if the modal view is dismissed.

<br>

# How to Negate the Autosave of a @Bindable

![SwiftUI Logo](https://developer.apple.com/news/images/og/swiftui-og.png)

> [!TIP]
> Use the acronym **`HNAB`** to navigate within the source code.

When using a SwiftData model, the standard way of passing the data to different views is to use `@Bindable`. When using `@Bindable` directly, all of the changes made from the child view automatically reflects to the parent view and vice versa. This guide is focused on how to modify changes in the child view that are not automatically being reflected in the parent view, such that the user can still have the option to make the update or cancel the update.

- Create a `@State` in the child view, and then set the initial value of those `@State` by the values of the `@Bindable`.
- Upon save, perform the update to replace the value of the `@Bindable` with the new/modified value of the `@State`.

Essentially, `@Bindable` must not be used directly in the child view.