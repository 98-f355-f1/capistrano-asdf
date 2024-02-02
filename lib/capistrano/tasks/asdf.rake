ASDF_SYSTEM_PATH = ENV["ASDF_SYSTEM_PATH"] || "~/.asdf"
ASDF_USER_PATH = "~/.asdf"

namespace :asdf do
  desc "Prints the ASDF and Ruby version on the target host"
  task :check do
    on roles(fetch(:asdf_roles, :all)) do
      if fetch(:log_level) == :debug
        puts capture(:asdf, "--version")
        puts capture(:ruby, "--version")
      end
    end
  end

  task :hook do
    on roles(fetch(:asdf_roles, :all)) do
      asdf_path = fetch(:asdf_custom_path)
      asdf_path ||= case fetch(:asdf_type)
      when :auto
        if test("[ -d #{ASDF_USER_PATH} ]")
          ASDF_USER_PATH
        elsif test("[ -d #{ASDF_SYSTEM_PATH} ]")
          ASDF_SYSTEM_PATH
        else
          ASDF_USER_PATH
        end
      when :system, :mixed
        ASDF_SYSTEM_PATH
      else # :user
        ASDF_USER_PATH
      end

      set :asdf_path, asdf_path
    end

    SSHKit.config.command_map[:asdf] = "#{fetch(:asdf_path)}/bin/asdf"

    asdf_prefix = "#{fetch(:asdf_path)}/bin/asdf #{fetch(:asdf_ruby_version)} do"
    fetch(:asdf_map_bins).each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(asdf_prefix)
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'asdf:hook'
  after stage, 'asdf:check'
end

namespace :load do
  task :defaults do
    set :asdf_map_bins, %w{gem rake ruby bundle}
    set :asdf_type, :auto
    set :asdf_ruby_version, "default"
  end
end
