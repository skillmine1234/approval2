module ActiveRecord::ConnectionAdapters
  class TableDefinition
    def approval_columns(*args)
      column(:approval_status, :string, limit: 1, default: 'U', null: false, comment: "the approval status of the record, A (approved), U (unapproved)")
      column(:last_action, :string, limit: 1, default: 'C', comment: "the last action on the record, C (create), U (update), D (delete)")
      column(:approved_id, :integer, comment: "the id of the approved record that was edited, and resulted in this unapproved record ")
      column(:approved_version, :integer, comment: "the lock_version of the approved record at the time it was edited, and resulted in this unapproved record")
    end
  end
end