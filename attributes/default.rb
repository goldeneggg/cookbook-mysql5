default['mysql5']['install_type'] = "source"

default['mysql5']['major_minor_ver'] = "5.5"
default['mysql5']['build_ver'] = "36"
default['mysql5']['ver'] = default['mysql5']['major_minor_ver'] + '.' + default['mysql5']['build_ver']

default['mysql5']['dependency_packages'] = ["cmake", "bison", "ncurses-devel"]

default['mysql5']['user'] = "mysql"
default['mysql5']['group'] = "mysql"
default['mysql5']['mysql_user'] = "root"
default['mysql5']['mysql_password'] = "proot"

# my.cnf default settings (= medium)
default['mysql5']['cnf_path'] = "/etc/my.cnf"
default['mysql5']['cnf_tmpl'] = "my-medium.cnf.erb"
default['mysql5']['server_port'] = 3306
default['mysql5']['server_socket'] = "/tmp/mysql.sock"
default['mysql5']['server_charset'] = "utf8"
default['mysql5']['client_charset'] = "utf8"
default['mysql5']['key_buffer_size'] = "16M"
default['mysql5']['max_allowed_packet'] = "1M"
default['mysql5']['table_open_cache'] = "64"
default['mysql5']['sort_buffer_size'] = "512K"
default['mysql5']['net_buffer_length'] = "8K"
default['mysql5']['read_buffer_size'] = "256K"
default['mysql5']['read_rnd_buffer_size'] = "512K"
default['mysql5']['myisam_sort_buffer_size'] = "8M"
default['mysql5']['long_query_time'] = "1"
default['mysql5']['expire_logs_days'] = "30"
default['mysql5']['sync_binlog'] = "1"
default['mysql5']['innodb_data_file_path'] = "ibdata1:10M:autoextend"
default['mysql5']['innodb_buffer_pool_size'] = "16M"
default['mysql5']['innodb_additional_mem_pool_size'] = "2M"
default['mysql5']['innodb_log_file_size'] = "5M"
default['mysql5']['innodb_log_buffer_size'] = "8M"
default['mysql5']['innodb_flush_log_at_trx_commit'] = "1"
default['mysql5']['innodb_lock_wait_timeout'] = "50"

# source
default['mysql5']['source']['add_path_users'] = {"root" => "/root", "vagrant" => "/home/vagrant"}

default['mysql5']['source']['archive_name'] = "mysql-#{default['mysql5']['ver']}"
default['mysql5']['source']['prefix'] = "/usr/local/mysql"
default['mysql5']['source']['root_src_work'] = "/root/src"
default['mysql5']['source']['cmake_option'] = "-DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DENABLED_LOCAL_INFILE=true -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_EXTRA_CHARSETS=all -DWITH_READLINE=ON"

default['mysql5']['source']['install_db_script'] = "#{default['mysql5']['source']['prefix']}/scripts/mysql_install_db"
default['mysql5']['source']['data_dir'] = "#{default['mysql5']['source']['prefix']}/data"
default['mysql5']['source']['log_dir'] = "/var/log/mysql"

default['mysql5']['source']['service_script_name'] = "mysql.server"
