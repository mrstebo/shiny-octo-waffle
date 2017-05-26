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
1. Loop through the keys (jobs) in the hash
2. Add to the `visited` array if we haven't seen it before, otherwise go to the next `job`
3. Find the nested dependencies for the current `job` and loop through them in reverse order
  - Raise a `SelfDependenyError` if we have a self referencing dependency
  - Raise a `CircularDependenyError` if we find a circular dependency
4. Add to the `visited` array if we haven't seen it before, otherwise go to the next `dependency`
5. Add the `dependency` to the `stack`
6. Add the parent `job` to the `stack`
7. Return a string of all the jobs in the `stack`
