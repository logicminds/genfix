# Genfix

Gemfix is a small utility that will bring all the types of puppet module dependencies together into a single entity.

## Summary
Currently when working on puppet modules there are multiple types of dependency files that are needed for various tools.
These files can be at least of of the following.

  - Librarian-puppet Puppetfile
  - Puppetlabs spec helper .fixtures.yml file
  - Puppet Modulefile
  - Puppet Metadata.json file
  
Each tool and file is designed for a slightly different purpose but underneath the covers they overlap each other greatly.
This means that we must specify the same information in multiple places, which for a devops professional is absurdly annoying.

So what this tool is designed to fix (in the shorterm) is to provide a bridge to other formats so that no matter what
format you need you only need to specify one source of module dependencies.

## Using
 
## Testing

```ruby
   bundle install
   bundle exec rake spec
```

## Contributing to genfix
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2015 Corey Osman. See LICENSE.txt for
further details.

