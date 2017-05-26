require_relative 'circular_dependency_error'
require_relative 'self_dependency_error'

class Jobs
  def build_order(build_sequence)
    return '' if build_sequence.empty?
    visited = []
    stack = []

    build_sequence.keys.each do |job|
      next if visited.include?(job)
      visited << job
      find_dependencies(job, build_sequence).reverse.each do |dependency|
        next if visited.include?(dependency)
        visited << dependency
        stack << dependency
      end
      stack << job
    end

    stack.map(&:to_s).join
  end

  private

  def find_dependencies(job, sequence, visited=[])
    return [] if sequence[job].nil?
    raise SelfDependenyError, "#{job} cannot depend on itself" if job == sequence[job]
    raise CircularDependenyError, "#{job} is a circular dependency" if visited.include?(sequence[job])
    [sequence[job]] + find_dependencies(sequence[job], sequence, visited + [job])
  end
end
