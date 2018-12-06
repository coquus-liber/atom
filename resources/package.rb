# atom_package
# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html

require 'etc'

property :name, String, name_property: true 
property :user, String, default: lazy{ |r| ::Etc.getpwuid(1000).name }
property :usr, Etc::Passwd, default: lazy{ |r| ::Etc.getpwnam(r.user) }
property :grp, Etc::Group, default: lazy{ |r| ::Etc.getgrgid(r.usr.gid) }
property :group, String, default: lazy {|r| r.grp.name }
property :home, String, default: lazy {|r| r.usr.dir }
property :dir, String, default: lazy {|r| ::File.join(r.home,'.atom') }
property :env, Hash, default: lazy { |r|
  { 
    'HOME': r.home, 
    'USER': r.user, 
    'USERNAME': r.user, 
    'LOGNAME': r.user
  }
}

load_current_value do
  # some Ruby for loading the current state of the resource
end

action :install do
  # https://docs.chef.io/resource_execute.html
  execute "apm install #{new_resource.name}" do
    cwd new_resource.home
    user new_resource.user
    group new_resource.group
    environment new_resource.env
    command "apm install #{new_resource.name} --verbose"
    live_stream true
    creates ::File.join(new_resource.dir,'packages', new_resource.name)
  end 
end

