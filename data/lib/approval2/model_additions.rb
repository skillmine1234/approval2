module Approval2
  module ModelAdditions
    extend ActiveSupport::Concern

    included do
      #audited except: [:approval_status, :last_action]
 
      # refers to the unapproved record in the common unapproved_record model, this is true only for U records
      has_one :unapproved_record_entry, :as => :approvable, :class_name => '::UnapprovedRecord'
 
      # refers to the approved/unapproved record in the model
      belongs_to :unapproved_record, :primary_key => 'approved_id', :foreign_key => 'id', :class_name => self.name#, :unscoped => true
      belongs_to :approved_record, :foreign_key => 'approved_id', :primary_key => 'id', :class_name => self.name#, :unscoped => true

      validates_uniqueness_of :approved_id, :allow_blank => true
      validate :validate_unapproved_record

      def self.default_scope
        where approval_status: 'A'
      end


      after_create :on_create_create_unapproved_record_entry
      after_destroy :on_destory_remove_unapproved_record_entries
      after_update :on_update_remove_unapproved_record_entries

    end

    def validate_unapproved_record
      errors.add(:base,"Unapproved Record Already Exists for this record") if !unapproved_record.nil? and (approval_status == 'A' and approval_status_was == 'A')
    end

    def approve
       return "The record version is different from that of the approved version" if !self.approved_record.nil? and self.approved_version != self.approved_record.lock_version    

  #    make the U the A record, also assign the id of the A record, this looses history
  #    self.approval_status = 'A'
  #    self.approved_record.delete unless self.approved_record.nil?
  #    self.update_column(:id, self.approved_id) unless self.approved_id.nil?   
  #    self.approved_id = nil


      if self.approved_record.nil?
        # create action, all we need to do is set the status to approved
        self.approval_status = 'A'
        return self
      end

      # edit action
      # copy all attributes of the U record to the A record, and delete the U record
      attributes = self.attributes.select do |attr, value|
        self.class.column_names.include?(attr.to_s) and
        ['id', 'approved_id', 'approval_status', 'lock_version', 'approved_version', 'created_at', 'updated_at', 'updated_by', 'created_by'].exclude?(attr)
      end

      self.class.unscoped do
        approved_record = self.approved_record
        approved_record.assign_attributes(attributes)
        approved_record.last_action = 'U'
        approved_record.updated_by = self.created_by
        self.destroy
        return approved_record
      end    
    end
    
    def can_destroy?
      # only unaproved records are allowed to be destroyed
      self.approval_status == 'U'
    end
    
    alias_method :enable_reject_button?, :can_destroy?

    def enable_approve_button?
      self.approval_status == 'U' ? true : false
    end

    def on_create_create_unapproved_record_entry
      if approval_status == 'U'
        UnapprovedRecord.create!(:approvable => self)
      end
    end
  
    def on_destory_remove_unapproved_record_entries
      if approval_status == 'U'
        unapproved_record_entry.delete
      end
    end
  
    def on_update_remove_unapproved_record_entries
      if approval_status == 'A' and approval_status_was == 'U'
        unapproved_record_entry.delete
      end
    end 
  end
end
