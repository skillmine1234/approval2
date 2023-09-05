require 'rails/generators'
require 'rails/generators/migration'

module Approval2
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "Add the migrations for unapproved_records"

      def self.next_migration_number(path)
        next_migration_number = current_migration_number(path) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def copy_migrations
        migration_template "create_unapproved_records.rb", "db/migrate/create_unapproved_records.rb"
      end

      def copy_models
        copy_file "unapproved_record.rb", "#{Rails.root}/app/models/unapproved_record.rb"
      end

      def copy_views
        ["index.html.haml", "_approve.html.haml"].each do |v|
          copy_file v, "#{Rails.root}/app/views/unapproved_records/#{v}"
          copy_file v, "#{Rails.root}/app/views/unapproved_records/#{v}"
        end
      end
      
      def copy_controllers
        copy_file "unapproved_records_controller.rb", "#{Rails.root}/app/controllers/unapproved_records_controller.rb"
      end
      
    end
  end
end