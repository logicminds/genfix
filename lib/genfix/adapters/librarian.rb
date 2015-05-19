require 'librarian/puppet/environment'
require 'librarian/puppet'
require 'librarian/action/resolve'
require 'librarian/puppet/action'

module Genfix
  module Adapters
    class LibrarianAdapter < DependencyBase

      def adapter_name
        'librarian'
      end

      # librarian-puppet which encompasses many of the following
      #      a. Puppetfile
      #      b. Modulefile
      #      c. metadata.json
      def read_source
        # the below call performs quite a few tasks, some of which we don't need
        # 1. resolve dependecies
        # 2. create Puppetfile (don't need)
        # 3. create .librarian directory  (don't need)
        #Librarian::Puppet::Action::Resolve.new(e, :force => true).run
        environment.spec
        environment.spec.dependencies
      end

      def to_dependency_format
        read_source
      end

      # outputs to librarian puppet objects, useful for version comparison
      def to_source_format(dependencies)
         # Librarian::Dependency.new('stdlib', "< 2.0.0"," >= 1.1.1")
         # Librarian::Dependency::Requirement.new("< 2.0.0"," >= 1.1.1")
         # Librarian::Manifest::Version("2.0.0")

      end

    end
  end
end

