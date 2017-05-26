# shiny-octo-waffle
Code exercise


## Examples

```ruby
# No dependencies
jobs = <<-JOBS
a =>
b =>
c =>
JOBS
Jobs.new.build_order(jobs)
# output: "abc"

# Single dependency
jobs = <<-JOBS
a =>
b => c
c =>
JOBS
Jobs.new.build_order(jobs)
# output: "acb"

# Nested dependencies
jobs = <<-JOBS
a =>
b => c
c => f
d => a
e => b
f =>
JOBS
Jobs.new.build_order(jobs)
# output: "afcbde"

# Job has dependency on itself
jobs = <<-JOBS
a =>
b =>
c => c
JOBS
Jobs.new.build_order(jobs)
# output: SelfDependenyError, "c cannot depend on itself"

# Job has a circular dependency
jobs => <<-JOBS
a =>
b => c
c => f
d => a
e =>
f => b
JOBS
Jobs.new.build_order(jobs)
# output: CircularDependenyError, "f is a circular dependency"
```


## How it works

Here are the steps we take to create the build order:
1. Convert the lines of the string to a hash
2. Convert the `build_sequence` into a hash that can be used by the `TSortableHash`
3. When transforming it will also check for self and cyclic dependencies and raise an error if one is found
4. Create a `TSortableHash` with the converted hash
5. Run the `tsort` method
6. Convert the resulting array back into a sequence of characters
