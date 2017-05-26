require_relative 'circular_dependency_error'
require_relative 'self_dependency_error'

class Jobs
  def build_order(sequence)
    sequence_hash = convert_to_hash(sequence)
    visited = []
    stack = []

    sequence_hash.keys.each do |job|
      next if visited.include?(job)
      visited << job
      find_dependencies(job, sequence_hash).reverse.each do |dependency|
        next if visited.include?(dependency)
        visited << dependency
        stack << dependency
      end
      stack << job
    end

    stack.map(&:to_s).join
  end

  private

  def convert_to_hash(build_sequence)
    return Hash[build_sequence.lines.map {|line| line.split('=>').map(&:strip)}]
  end

  def find_dependencies(job, sequence, visited=[])
    return [] if sequence[job].nil?
    raise SelfDependenyError, "#{job} cannot depend on itself" if job == sequence[job]
    raise CircularDependenyError, "#{job} is a circular dependency" if visited.include?(sequence[job])
    [sequence[job]] + find_dependencies(sequence[job], sequence, visited + [job])
  end
end
