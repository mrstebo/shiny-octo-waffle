require_relative 'circular_dependency_error'
require_relative 'self_dependency_error'

class Jobs
  def build_order(build_sequence)
    return '' if build_sequence.empty?
    visited = []
    stack = []

    build_sequence.keys.each do |key|
      next if visited.include?(key)
      visited << key
      find_dependencies(key, build_sequence).reverse.each do |dependency|
        next if visited.include?(dependency)
        visited << dependency
        stack << dependency
      end
      stack << key
    end

    stack.map(&:to_s).join
  end

  private

  def find_dependencies(key, sequence, visited=[])
    return [] if sequence[key].nil?
    raise SelfDependenyError, "#{key} cannot depend on itself" if key == sequence[key]
    raise CircularDependenyError, "#{key} is a circular dependency" if visited.include?(sequence[key])
    [sequence[key]] + find_dependencies(sequence[key], sequence, visited + [key])
  end
end
