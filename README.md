# shiny-octo-waffle
Code exercise


## Examples

```ruby
# No dependencies
Jobs.new.build_order({
  a: nil,
  b: nil,
  c: nil
})
# output: "abc"

# Single dependency
Jobs.new.build_order({
  a: nil,
  b: :c,
  c: nil
})
# output: "acb"

# Nested dependencies
Jobs.new.build_order({
  a: nil,
  b: :c,
  c: :f,
  d: :a,
  e: :b,
  f: nil
})
# output: "afcbde"

# Job has dependency on itself
Jobs.new.build_order({
  a: nil,
  b: nil,
  c: :c
})
# output: SelfDependenyError, "c cannot depend on itself"

# Job has a circular dependency
Jobs.new.build_order({
  a: nil,
  b: :c,
  c: :f,
  d: :a,
  e: nil,
  f: :b
})
# output: CircularDependenyError, "f is a circular dependency"
```


## How it works

Here are the steps we take to create the build order:
1. Convert the `build_sequence` into a hash that can be used by the `TSortableHash`
2. When transforming it will also check for self and cyclic dependencies and raise an error if one is found
3. Create a `TSortableHash` with the converted hash
4. Run the `tsort` method
5. Convert the resulting array back into a sequence of characters
