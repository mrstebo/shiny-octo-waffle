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
2. Loop through the keys (jobs) in the hash
3. Add to the `visited` array if we haven't seen it before, otherwise go to the next `job`
4. Find the nested dependencies for the current `job` and loop through them in reverse order
  - Raise a `SelfDependenyError` if we have a self referencing dependency
  - Raise a `CircularDependenyError` if we find a circular dependency
5. Add to the `visited` array if we haven't seen it before, otherwise go to the next `dependency`
6. Add the `dependency` to the `stack`
7. Add the parent `job` to the `stack`
8. Return a string of all the jobs in the `stack`
