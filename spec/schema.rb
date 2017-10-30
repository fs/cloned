ActiveRecord::Schema.define do
  create_table :accounts do |t|
    t.string :name
    t.datetime :created_at, null: false
    t.datetime :updated_at, null: false
  end

  create_table :departments do |t|
    t.integer :account_id, null: false
    t.string :name
    t.string :region
    t.string :employees_count
    t.datetime :created_at, null: false
    t.datetime :updated_at, null: false
  end

  create_table :employees do |t|
    t.integer :department_id, null: false
    t.string :firstname
    t.string :lastname
    t.datetime :created_at, null: false
    t.datetime :updated_at, null: false
  end

  create_table :payrolls do |t|
    t.integer :employee_id, null: false
    t.datetime :date, null: false
    t.decimal :total, precision: 12, scale: 4
    t.datetime :created_at, null: false
    t.datetime :updated_at, null: false
  end

  create_table :addresses do |t|
    t.string :addressable_type
    t.integer :addressable_id
    t.string :zipcode
    t.string :adds
  end
end
