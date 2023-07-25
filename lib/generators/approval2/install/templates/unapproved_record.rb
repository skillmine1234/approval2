class UnapprovedRecord < ActiveRecord::Base
  belongs_to :approvable, :polymorphic => true, :unscoped => true
end