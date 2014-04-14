case node["platform_family"]
    when 'mac_os_x'
        unless File.exists?("/usr/libexec/apache2/mod_jk.so")

          remote_file "#{Chef::Config[:file_cache_path]}/tomcat-connectors-1.2.37-src.tar.gz" do
            source "http://www.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.37-src.tar.gz"
            owner node['current_user']
          end

          execute "extract tomcat-connectors" do
            command "tar vxzf #{Chef::Config[:file_cache_path]}/tomcat-connectors-1.2.37-src.tar.gz -C #{Chef::Config[:file_cache_path]}/"
            user node['current_user']
          end

          execute "symlink Xcode" do
            command "cd /Applications/Xcode.app/Contents/Developer/Toolchains;sudo ln -s XcodeDefault.xctoolchain OSX10.8.xctoolchain"
          end

          bash "install_program" do
            user "root"
            cwd "#{Chef::Config[:file_cache_path]}/tomcat-connectors-1.2.37-src/native"
            code <<-EOH
                ./configure --with-apxs=/usr/sbin/apxs
                make
                make install
                /usr/sbin/apxs -a -e -n "jk" mod_jk.so
            EOH
          end

        end

        directory "/usr/logs" do
            owner "root"
            group "root"
            mode 0777
            action :create
            recursive true
        end
    when 'debian'
        Chef::Log.debug("This recipe is OSX only")
end



