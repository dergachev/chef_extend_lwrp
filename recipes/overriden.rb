#
# Cookbook Name:: extend_lwrp
# Recipe:: base
#
# Copyright 2012, Alex Dergachev
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# see resources/greeting.rb and providers/greeting.rb
extend_lwrp_greeting "Overriden-Oliver" do 
  action :say_hello
end

# Note on ordering:
# - Recipes files are loaded after providers; see http://wiki.opscode.com/display/chef/Anatomy+of+a+Chef+Run
# - Reopening the Provider class _after_ invoking the Resource (above) is fine, 
#   since all this happens in Compilation, while providers are invoked during execution. 
#   See http://wiki.opscode.com/display/chef/Evaluate+and+Run+Resources+at+Compile+Time 
# - All subsequent recipes will be affected by this reopening.
class Chef::Provider::ExtendLwrpGreeting 
  def greeting_format(name)
    return "Bonjour, " + name 
  end
end
