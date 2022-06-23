# /opt/sap/ASE-16_0/bin/srvbuildres -D /home/sybase/ -r /opt/sap/ASE-16_0/init/sample_resource_files/ttsheng.srvbuild.adaptive_server.rs
sybinit.release_directory: USE_DEFAULT
sybinit.product: sqlsrv
sqlsrv.server_name: ase100
sqlsrv.sa_password: Pass
sqlsrv.new_config: yes
sqlsrv.do_add_server: yes
sqlsrv.network_protocol_list: tcp
sqlsrv.network_hostname_list: ip-10-0-0-95.us-east-2.compute.internal
sqlsrv.network_port_list: 5000
sqlsrv.application_type: USE_DEFAULT
sqlsrv.server_page_size: USE_DEFAULT
sqlsrv.force_buildmaster: no
sqlsrv.master_device_physical_name: /opt/sap/data/master.dat
sqlsrv.master_device_size: USE_DEFAULT
sqlsrv.master_database_size: USE_DEFAULT
sqlsrv.errorlog: USE_DEFAULT
sqlsrv.do_upgrade: no
sqlsrv.sybsystemprocs_device_physical_name: /opt/sap/data/sybsystemprocs.dat
sqlsrv.sybsystemprocs_device_size: USE_DEFAULT
sqlsrv.sybsystemprocs_database_size: USE_DEFAULT
sqlsrv.sybsystemdb_device_physical_name: /opt/sap/data/sybsystemdb.dat
sqlsrv.sybsystemdb_device_size: USE_DEFAULT
sqlsrv.sybsystemdb_database_size: USE_DEFAULT
sqlsrv.tempdb_device_physical_name: /opt/sap/data/tempdb.dat
sqlsrv.tempdb_device_size: USE_DEFAULT
sqlsrv.tempdb_database_size: USE_DEFAULT
sqlsrv.default_backup_server: backup_ase100
#sqlsrv.addl_cmdline_parameters: 
sqlsrv.do_configure_pci: no
sqlsrv.sybpcidb_device_physical_name: /opt/sap/data/sybpcidb.dat
sqlsrv.sybpcidb_device_size: USE_DEFAULT
sqlsrv.sybpcidb_database_size: USE_DEFAULT
# If sqlsrv.do_optimize_config is set to yes, both sqlsrv.avail_physical_memory and sqlsrv.avail_cpu_num need to be set.
sqlsrv.do_optimize_config: no
sqlsrv.avail_physical_memory: 4G
sqlsrv.avail_cpu_num: 2
# Valid only if Remote Command and Control Agent for ASE is installed
sqlsrv.configure_remote_command_and_control_agent_ase: no
# Valid only if ASE Cockpit is installed.
# If set to yes, sqlsrv.technical_user and sqlsrv.technical_user_password are required.
sqlsrv.enable_ase_for_ase_cockpit_monitor: no
sqlsrv.technical_user:
sqlsrv.technical_user_password:
sqlsrv.configfile: /opt/sap/configfile
sqlsrv.shmem: /opt/sap/shmem
