# Approval2

A trivial implementation of the 4 eyes principle. All record actions require an approval to take effect.

Models that require an approval have a column called approval_status, a value of U implies that the record is un-approved, and a value of A implies that the record is approved.

A default scope on the model ensures that only records with approval_status = 'A' are used.

 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'approval2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install approval2

## Usage

The gem provides a generator to get started

```ruby
rails g approval2:install
```
This creates a migration for unapproved_records, and its associated model & controller. This is used to keep track of all unapproved records across the application, and can be used to create an 'approval worklist'.

Models that need an approval, should have the following columns 

1. approval_status
2. approved_version
3. approved_id
4. last_action

These columns can be added by calling 'approval_columns' in the migration. This method is added by the gem to the TableGeneator.

In addition to these columns, the model should include the module Approval2::ModelAdditions in its class.

The gem does not yet modify the routes, and an approve action needs to be added for each model manually. 

All unique indexes on the model need to be modified to include 'approval_status' as an additional column, this is required because the Edit action creates a new record. 

## The Approval Cycle

### Create
When a record is created, it has approval_status 'U', and a entry is added to unapproved_records. 

When the record is approved, the approval_status is updated from 'U' to 'A' 

### Edit
When a record is edited, a clone of the record is created. This clone has approval_status = 'U and the approved_version and approved_id is set to the lock_version & id of the record that was edited. This clone is persisted, and you now have 2 records in the table, one with approval_status = A (the record that was edited, but without any changes), and one with approval_status = U (the clone, with the changes applied). 

When the changes are approved, the record with approval_status = 'A' is deleted, and the approval_status of the cloned record is changed from 'U' to 'A'. To prevent buried updates, this is done only if the lock_version of the A record is still the same as the approved_version of the U record . ( It is expected that any application that updates such records increments lock_version whenever it updates an A record)





## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/approval2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

