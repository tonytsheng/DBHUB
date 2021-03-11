# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

export ORACLE_HOME=/opt/oracle/instantclient_19_9
export LD_LIBRARY_PATH=/opt/oracle/instantclient_19_9
export PATH=$PATH:$ORACLE_HOME:/opt/mssql-tools/bin:/usr/bin:/home/ec2-user/DBHUB/BIN

# User specific environment and startup programs

alias push_dbhub='git push git@github.com:tonytsheng/DBHUB.git master'
complete -C aws_completer aws

