# extend_lwrp

## Description

Example cookbook showing how to use Ruby mixins to extend an LWRP provider from a recipe

## Installation

Clone this repository into your `CHEF-REPO/cookbooks/extend_lwrp`:

```bash
  # Be sure to name the cookbook "extend_lwrp", not "chef_extend_lwrp"
  git clone git@github.com:dergachev/chef_extend_lwrp.git extend_lwrp 
```

## Usage

This cookbook defines a resource `greeting`, which outputs a log message with a greeting.
Include `recipe[extend_lwrp::base]` to see the base `greeting` LWRP in action. 
Include `recipe[extend_lwrp::overriden]` to see the overriden `greeting` lwrp in action.
Look at the all the code to learn about how this was achieved.

## Trying it out with vagrant/shef

Start shef in the vagrant vm:

```bash
  vagrat ssh
  cd /tmp/vagrant-chef-1 #or whatever the right path is
  sudo shef -s -c ./solo.rb -j ./dna.json # solo modo, with default vagrant chef-solo config
```

Run the following in shef on vagrant:

```ruby
  # first confirm that the default greeting behavior
  chef >          recipe                                   #enter recipe mode
  chef:recipe >   extend_lwrp_greeting("Base Bob") # loads greeting resource with default action 
  chef:recipe >   run_chef    # executes loaded resources; see that default greeting is printed

  # now confirm that overriding works
  chef:recipe >   class Chef::Provider::ExtendLwrpGreeting ; def greeting_format(name); return "Bonjour, " + name ; end ; end
  chef:recipe >   run_chef    # executes loaded resources; see that the overriden greeting is printed
```

## Resources

### LWRP 

The essentials:
* http://wiki.opscode.com/display/chef/Resources+and+Providers
* http://wiki.opscode.com/display/chef/Providers 
* http://wiki.opscode.com/display/chef/Lightweight+Resources+and+Providers+(LWRP)
* http://www.slideshare.net/jtimberman/understanding-lwrp-development

Other background: 
* http://wiki.opscode.com/display/chef/Libraries (not as important here)
* http://wiki.opscode.com/display/chef/Anatomy+of+a+Chef+Run
* http://wiki.opscode.com/display/chef/Evaluate+and+Run+Resources+at+Compile+Time (see chef example below)

```ruby
  # the following is how to do static execution of resources
  chef > recipe
  chef:recipe >   p = package "netcat" do ; action :nothing ; end
  chef:recipe >   p.run_action :install
```

Discussions about LWRP subclassing:
* http://community.opscode.com/search?query=subclass&scope=irc_log
* http://community.opscode.com/search?query=mixin&scope=irc_log
* http://community.opscode.com/chat/chef-hacking/2012-04-20#id-92459
* http://tickets.opscode.com/browse/CHEF-2308 (deprecated provider shadowing)
* https://gist.github.com/1585177 (didn't read, but might be relevant)

### Shef

* http://www.opscode.com/blog/2009/06/01/cool-chef-tricks-install-and-use-rubygems-in-a-chef-run/
* http://wiki.opscode.com/display/chef/Getting+Started+with+Shef
* http://wiki.opscode.com/display/chef/Shef#Shef-DebuggingRecipeswithShef
* http://stevendanna.github.com/blog/2012/01/28/shef-debugging-tips-1/
* http://tickets.opscode.com/browse/CHEF-3411 
  * Explains that error "Errno::ENOENT: No such file or directory - (irb#1)" is caused by shef not knowing how to print exceptions in LWRPs

NB: If you edit a recipe and add "breakpoint 'Name'", and shef will break to it. However I never 
figured out how that's useful, since shef seems to only break outside resource definitions


### Ruby mixins

* http://www.vitarara.org/cms/ruby_metaprogamming_declaratively_adding_methods_to_a_class
* http://blog.jayfields.com/2006/05/ruby-extend-and-include.html
* http://railstips.org/blog/archives/2009/05/15/include-vs-extend-in-ruby/
* http://stackoverflow.com/questions/5944278/overriding-method-by-another-defined-in-module
  * Explains why `include(Modulname)` doesn't work for overriding existing instance methods

### Motivation

This cookbook was written in the course of figuring out how to extend
fnichol/chef-homesick to make it compatible with SSH agent forwarding.  
See https://github.com/dergachev/chef_homesick_agent
