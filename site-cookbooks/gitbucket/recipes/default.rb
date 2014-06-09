#
# Cookbook Name:: gitbucket
# Recipe:: default
#

#
# Apacheインストール
#
package "httpd" do
    action :install
end

service "httpd" do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
end

#
# Tomcatインストール準備
#
package "yum-plugin-priorities" do
    action :install
end

cookbook_file "/tmp/jpackage-release-6-3.jpp6.noarch.rpm" do
    mode 00644
end

package "jpackage" do
    action :install
    source "/tmp/jpackage-release-6-3.jpp6.noarch.rpm"
    provider Chef::Provider::Package::Rpm
end

group "tomcat" do
  group_name "tomcat"
  gid 91
  action [:create]
end

user "tomcat" do
  comment "tomcat"
  uid 91
  group "tomcat"
  home "/home/tomcat"
  shell "/bin/false"
  password nil
  supports :manage_home => true
  action [:create, :manage]
end

#
# Tomcatインストール
#
package "tomcat7-webapps" do
    action :install
end

package "tomcat7-admin-webapps" do
    action :install
end

service "tomcat7" do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
end

#
# GitBucket配置
#
cookbook_file "/var/lib/tomcat7/webapps/gitbucket.war" do
end
