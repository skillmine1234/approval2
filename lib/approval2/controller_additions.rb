module Approval2
  module ControllerAdditions
    extend ActiveSupport::Concern

    included do
      before_action :before_edit, only: :edit
      before_action :before_approve, only: :approve
      #before_action :before_index, only: :index
    end


    private 
    
    def modelName
      self.class.name.sub("Controller", "").underscore.split('/').last.singularize
    end
    
    def modelKlass
      moduleName = self.class.name.include?("::") ? self.class.name.split("::").first : ""
      "#{moduleName}::#{modelName.classify}".constantize
    end

    def before_index
      if (params[:approval_status].present? and params[:approval_status] == 'U') 
        x = modelKlass.unscoped.where("approval_status =?",'U').order("id desc")
        instance_variable_set("@#{modelName}s", x)
      end
    end

    def before_edit
      x = modelKlass.unscoped.find_by_id(params[:id])
      if x.approval_status == 'A' && x.unapproved_record.nil?
        params = (x.attributes).merge({:approved_id => x.id,:approved_version => x.lock_version})
        x = modelKlass.new(params)
      end

      instance_variable_set("@#{modelName}", x)
    end

    def before_approve
      x = modelKlass.unscoped.find(params[:id])
      modelKlass.transaction do
        approved_record = x.approve
        if approved_record.save
          instance_variable_set("@#{modelName}", approved_record)
          flash[:alert] = "#{modelName.humanize.titleize} record was approved successfully"
        else
          msg = approved_record.errors.full_messages
          flash[:alert] = msg
          instance_variable_set("@#{modelName}", x)
          raise ActiveRecord::Rollback
        end
      end
    end    
  end
end

# ActionController::Base.class_eval do
  # include Approval2::ControllerAdditions
# end
