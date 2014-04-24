#
# Cookbook Name:: seafile
# Recipe:: default
#
# Copyright 2014, Christian Fischer, computerlyrik
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

# Database setup
node['seafile']['server']['db_pass'].set_unless = secure_password

%w(python2.7 python-setuptools python-simplejson python-imaging sqlite3).each do |pkg|
  package pkg
end

url = 'http://seafile.googlecode.com/files/seafile-server_' + node['seafile']['server']['version'] + 
if node['kernel']['machine'] =~ 'x86_64' do
  url += '_x86-64.tar.gz'
else
  url += '_i386.tar.gz'
end

path = '/usr/local/seafile'
ark 'seafile' do
  url url
end

template 'ccnet.conf'
template 'seafile.conf'
template 'seahub_settings.py'


service 'seafile' do
  start_command path + '/seafile.sh start'
  stop_command path + '/seafile.sh stop'
  restart_command path + '/seafile.sh restart'
  action :start
end

service 'seahub' do
  start_command path + '/seahub.sh ' + node['seafile']['server']['web_port'] + ' start'
  stop_command path + '/seahub.sh stop'
  action :start
end
