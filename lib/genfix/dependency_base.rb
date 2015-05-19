require 'librarian/puppet/environment'

class DependencyBase
  attr_reader :project_path

  def initialize(path)
    @project_path = path
  end

  def environment
    @environment ||= Librarian::Puppet::Environment.new(:project_path => project_path)
  end

  def normalize_name(name)
    name.split('-').last
  end

  def adapter_name
    raise NotImplementedError
  end

  def list
    to_dependency_format
  end

  # gather the dependency list from the given source file
  def read_source
    raise NotImplementedError
  end

  # convert librarian-puppet format to adapter format
  def to_source_format
     raise NotImplementedError
  end

  def write_to_source
    raise NotImplementedError
  end

  # convert adapter format to librarian-puppet format
  def to_dependency_format
    raise NotImplementedError
  end

  def self.to_source_format(dependencies, project_path)
    raise NotImplementedError

  end

  def self.write_to_source(dependencies, project_path)
    raise NotImplementedError
  end

end
