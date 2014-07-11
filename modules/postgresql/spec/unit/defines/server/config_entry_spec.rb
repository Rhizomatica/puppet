require 'spec_helper'

describe 'postgresql::server::config_entry', :type => :define do
  let :facts do
    {
      :osfamily => 'RedHat',
      :operatingsystem => 'RedHat',
      :operatingsystemrelease => '6.4',
      :kernel => 'Linux',
      :concat_basedir => tmpfilename('contrib'),
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let(:title) { 'config_entry'}

  let :target do
    tmpfilename('postgresql_conf')
  end

  context "syntax check" do
    let :pre_condition do
      "class {'postgresql::server':}"
    end

    let(:params) { { :ensure => 'present'} }
    it { should contain_postgresql__server__config_entry('config_entry') }
  end
end

