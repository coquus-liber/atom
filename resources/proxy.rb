# atom_proxy
# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html

require 'etc'

property :proxy, String, name_property: true 
property :http_proxy, String, default: lazy{ |r| r.proxy }
property :https_proxy, String, default: lazy{ |r| r.proxy }
property :user, String, default: lazy{ |r| ::Etc.getpwuid(1000).name }
property :usr, Etc::Passwd, default: lazy{ |r| ::Etc.getpwnam(r.user) }
property :grp, Etc::Group, default: lazy{ |r| ::Etc.getgrgid(r.usr.gid) }
property :group, String, default: lazy {|r| r.grp.name }
property :home, String, default: lazy {|r| r.usr.dir }
property :dir, String, default: lazy {|r| ::File.join(r.home,'.atom') }
property :apmrc, String, default: lazy {|r| ::File.join(r.dir,'.apmrc') }
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

action :create do

  # https://docs.chef.io/resource_directory.html
  directory new_resource.dir do
    mode '0755'
    owner new_resource.user
    group new_resource.group
  end
  
  # https://docs.chef.io/resource_file.html
  file new_resource.apmrc do
    content <<~APMRC
      http-proxy=#{new_resource.http_proxy}
      https-proxy=#{new_resource.https_proxy}
      proxy=#{new_resource.proxy}
      progress=true
    APMRC
    mode '0644'
    owner new_resource.user
    group new_resource.group
  end

end

