require 'byebug'

class Distro
  attr_reader :vagrantfile, :basename, :virtualbox_name, :rendered_box_name, :packaging_tool

  def initialize(vagrantfile)
    @vagrantfile = vagrantfile
    init_names
  end

  def link_vagrantfile
    vagrantfile_name = 'Vagrantfile'

    if File.exists?(vagrantfile_name)
      File.unlink(vagrantfile_name)
    end
    File.symlink(vagrantfile, vagrantfile_name)
  end

  def reset
    run_command('vagrant destroy --force')
    run_command('vagrant up')
  end

  def halt
    run_command('vagrant halt')
  end

  def prepare
    # @packaging_tool ||= packaging_tool

    run_vagrant_ssh_command("sudo #{packaging_tool} update")
    # $ dpkg --force-help
    # [!] confold         Always use the old config files, don't prompt
    # [!] confdef         Use the default option for new config files if one is
    #                     available, don't prompt. If no default can be found,
    #                     you will be prompted unless one of the confold or
    #                     confnew options is also given
    run_vagrant_ssh_command("sudo DEBIAN_FRONTEND=noninteractive #{packaging_tool} dist-upgrade -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'")
  end

  def install_rails
    run_vagrant_ssh_command("gem install rails")
  end

  def set_dns
    run_vagrant_ssh_command('echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null')
  end

  def setup_laptop(colored_output = true)
    colored = colored_output ? '--colored-output' : ''
    run_vagrant_ssh_command("echo vagrant | bash /vagrant/linux #{colored}")
    puts "Installing rails gem"
    install_rails
  end

  def active_shell
    run_vagrant_ssh_command_in_zsh_context('echo $SHELL')
  end

  def installed_ruby_version
    run_vagrant_ssh_command_in_zsh_context('ruby --version')
  end

  def generate_rails_app
    run_vagrant_ssh_command_in_zsh_context(
      'rm -Rf ~/test_app && cd ~ && rails new test_app'
    )
  end

  def scaffold_and_model_generation
    run_vagrant_ssh_command_in_zsh_context(
      'cd ~/test_app && rails g scaffold post title:string'
    )
  end

  def database_migration
    run_vagrant_ssh_command_in_zsh_context(
      'cd ~/test_app && rake db:create db:migrate db:test:prepare'
    )
  end

  def package
    run_vagrant_ssh_command('rm -Rf ~/test_app')
    # run_vagrant_ssh_command('sudo aptitude clean')
    run_vagrant_ssh_command("sudo #{packaging_tool} clean")

    run_command(
      %Q|vagrant package --base "#{virtualbox_name}" --output "#{rendered_box_name}"|
    )
  end

  def packaged?
    File.exists?(rendered_box_name)
  end

  def allow_change_shell_without_pwd
    regex = %Q("/sufficient\\spam_rootok.so/c\\auth        sufficient  pam_permit.so")
    run_vagrant_ssh_command("sudo sed -i #{regex} /etc/pam.d/chsh")
    # run_vagrant_ssh_command('sudo sed -i "/sufficient\\spam_rootok.so/c\auth        sufficient  pam_permit.so" /etc/pam.d/chsh')
  end

  private

  def init_names
    @basename = File.basename(vagrantfile).gsub('Vagrantfile.', '')
    @virtualbox_name = "laptop-#{basename}"
    @rendered_box_name = "#{basename}-with-laptop.box"
  end

  def run_vagrant_ssh_command(command)
    run_command("vagrant ssh -c '#{command}'")
  end

  def run_vagrant_ssh_command_in_zsh_context(command)
    run_command(%Q|vagrant ssh -c 'zsh -i -l -c "#{command}"'|)
  end

  def run_command(command)
    Cocaine::CommandLine.logger = Logger.new(STDOUT)
    Cocaine::CommandLine.new(command, '', :logger => Logger.new(STDOUT)).run
    # Cocaine::CommandLine.new(command, '').run
  end

  def packaging_tool
    @packaging_tool ||= begin
      run_vagrant_ssh_command('which aptitude')
    rescue Cocaine::ExitStatusError
      puts "This VM is not using aptitude yet. Switching to apt-get for the moment."
      'apt-get'
    else
      'aptitude'
    end
  end
end
