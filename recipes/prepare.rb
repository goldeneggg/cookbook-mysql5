node['mysql5']['dependency_packages'].each do |pkg|
    package pkg do
        action :install
    end
end

group node['mysql5']['group'] do
    action :create
end

user node['mysql5']['user'] do
    gid "#{node['mysql5']['group']}"
    shell "/sbin/nologin"
    action :create
end

