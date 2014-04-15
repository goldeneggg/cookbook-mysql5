#
# Cookbook Name:: mysql5.5
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# include "prepare" recipe
include_recipe "cookbook-mysql5::prepare"

directory "#{node['mysql5']['source']['root_src_work']}" do
    owner "root"
    action :create
    not_if "ls #{node['mysql5']['source']['root_src_work']}"
end

execute "wget_mysql" do
    command "cd #{node['mysql5']['source']['root_src_work']}; wget http://dev.mysql.com/get/Downloads/MySQL-#{node['mysql5']['major_minor_ver']}/#{node['mysql5']['source']['archive_name']}.tar.gz/from/http://cdn.mysql.com/ -O #{node['mysql5']['source']['archive_name']}.tar.gz"
    not_if "ls #{node['mysql5']['source']['root_src_work']}/#{node['mysql5']['source']['archive_name']}.tar.gz"
end

execute "extract_mysql_tarball" do
    command "cd #{node['mysql5']['source']['root_src_work']}; tar -zxvf #{node['mysql5']['source']['archive_name']}.tar.gz"
    not_if "ls #{node['mysql5']['source']['root_src_work']}/#{node['mysql5']['source']['archive_name']}"
end

script "install_mysql5" do
    interpreter "bash"
    user "root"
    cwd node['mysql5']['source']['root_src_work']
    code <<-EOH
        cd #{node['mysql5']['source']['archive_name']}
        cmake . -DCMAKE_INSTALL_PREFIX=#{node['mysql5']['source']['prefix']} #{node['mysql5']['source']['cmake_option']}
        make
        make install
    EOH
    not_if "ls #{node['mysql5']['source']['prefix']}"
end

# mkdir log_dir
directory "#{node['mysql5']['source']['log_dir']}" do
    owner "#{node['mysql5']['user']}"
    group "#{node['mysql5']['group']}"
    mode 0644
    action :create
end

# setup my.cnf using erb file
template "#{node['mysql5']['cnf_path']}" do
    source "#{node['mysql5']['cnf_tmpl']}"
    mode 0644
    owner "root"
    group "root"
end

# install mysql service script
template "/etc/init.d/#{node['mysql5']['source']['service_script_name']}" do
    source "mysql.server.erb"
    owner "root"
    group "root"
    mode 0755
end
#execute "install_mysql_server" do
#    user "root"
#    command "cp #{node['mysql5']['work_src_dir']}/#{node['mysql5']['archive_name']}/support-files/#{node['mysql5']['service_script_name']} /etc/init.d/#{node['mysql5']['service_script_name']}; chmod 777 /etc/init.d/#{node['mysql5']['service_script_name']}"
#    not_if "ls /etc/init.d/#{node['mysql5']['service_script_name']}"
#end

# register service
service "#{node['mysql5']['source']['service_script_name']}" do
    action :nothing
end

script "install_db" do
    interpreter "bash"
    user "root"
    cwd node['mysql5']['source']['prefix']
    code <<-EOH
        cd ..
        chwon -R #{node['mysql5']['user']}:#{node['mysql5']['group']} #{node['mysql5']['source']['prefix']}
        cd #{node['mysql5']['source']['prefix']}
        #{node['mysql5']['source']['install_db_script']} --user=#{node['mysql5']['user']} --basedir=#{node['mysql5']['source']['prefix']} --datadir=#{node['mysql5']['source']['data_dir']} --no-defaults
        chown -R root:root .
        chown -R #{node['mysql5']['user']}:#{node['mysql5']['group']} #{node['mysql5']['source']['data_dir']}
    EOH
    not_if "ls #{node['mysql5']['source']['data_dir']}/performance_schema"
    notifies :restart, "service[mysql.server]", :immediately
end

# set admin password
execute "set_admin_password" do
    user "root"
    cwd "#{node['mysql5']['source']['prefix']}/bin"
    command "./mysqladmin -u #{node['mysql5']['mysql_user']} password \"#{node['mysql5']['mysql_password']}\""
    only_if "#{node['mysql5']['source']['prefix']}/bin/mysqlshow -u #{node['mysql5']['mysql_user']}"
end

# register chkconfig
#execute "chkconfig mysql.server on" do
#    command "chkconfig mysql.server on"
#    not_if "chkconfig --list | grep mysql.server | grep 3:on"
#    action :nothing
#end
#
#execute "chkconfig mysql.server add" do
#    command "chkconfig --add mysql.server"
#    not_if "chkconfig --list | grep mysql.server"
#    notifies :run, "execute[chkconfig mysql.server on]", :delayed
#end
#

# add_path_users should be defined key-value hash
#node['mysql5']['source']['add_path_users'].each do |user|
node['mysql5']['source']['add_path_users'].each do |user,home|
    execute "add_path_#{user}" do
        user "#{user}"
        command "echo \"export PATH=#{node['mysql5']['source']['prefix']}/bin:$PATH\" >> #{home}/.bash_profile"
        action :run
        not_if "grep #{node['mysql5']['source']['prefix']} #{home}/.bash_profile"
    end
end
