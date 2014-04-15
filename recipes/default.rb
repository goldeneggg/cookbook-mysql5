#
# Cookbook Name:: mysql5
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# install from source
include_recipe "cookbook-mysql5::#{node['mysql5']['install_type']}"
