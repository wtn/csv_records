ActiveRecord::Schema.define do

  create_table "users", :force => true do |t|
    t.column "name",       :text
    t.column "salary",     :integer,  :default => 70000
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "kind",       :text
  end

end
