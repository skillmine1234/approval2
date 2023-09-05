require 'will_paginate/array'

class UnapprovedRecordsController < ApplicationController
  def index
    result = []
    UnapprovedRecord.distinct.select(:approvable_type).each do |m|
      if m.approvable_type.constantize.column_names.include?('approval_status')
        count = UnapprovedRecord.where("approvable_type =?", m.approvable_type).count 
        result << {:record_type => m.approvable_type, :record_count => count}
      end
    end

    @records = result.paginate(:per_page => 10, :page => params[:page]) rescue []
    
    # the approval2 gem requires a known session variable to include any redirect params to be sent to the unapproved_records_path
    # for the reject action
    session[:approval2_redirect_params] = {param1: 'some_param', param2: 'some_other_param'}
    
  end
end
