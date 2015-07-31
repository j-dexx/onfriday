# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120215120751) do

  create_table "addresses", :force => true do |t|
    t.string   "surname"
    t.string   "first_names"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "postcode"
    t.string   "country"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",    :default => false
    t.datetime "recycled_at"
    t.boolean  "display",     :default => true
    t.integer  "position",    :default => 0
    t.string   "state"
  end

  create_table "administrators", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "last_login_at"
    t.integer  "login_count",        :default => 0
    t.boolean  "super_admin",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "css"
    t.string   "perishable_token",   :default => "",    :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_alt"
  end

  add_index "administrators", ["perishable_token"], :name => "index_administrators_on_perishable_token"

  create_table "administrators_roles", :id => false, :force => true do |t|
    t.integer "administrator_id"
    t.integer "role_id"
  end

  create_table "articles", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.text     "body"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",           :default => false
    t.datetime "recycled_at"
    t.boolean  "display",            :default => true
    t.integer  "position",           :default => 0
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_alt"
  end

  create_table "basket_items", :force => true do |t|
    t.integer  "basket_id"
    t.integer  "product_id"
    t.integer  "amount",           :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "basket_item_type", :default => 0
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.float    "value",            :default => 0.0
    t.string   "delivery_type"
    t.integer  "target_id"
  end

  create_table "baskets", :force => true do |t|
    t.integer  "user_id"
    t.text     "delivery_summary"
    t.string   "billing_surname"
    t.string   "billing_first_names"
    t.string   "billing_address_1"
    t.string   "billing_address_2"
    t.string   "billing_city"
    t.string   "billing_postcode"
    t.string   "billing_country"
    t.string   "delivery_surname"
    t.string   "delivery_first_names"
    t.string   "delivery_address_1"
    t.string   "delivery_address_2"
    t.string   "delivery_city"
    t.string   "delivery_postcode"
    t.string   "delivery_country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "gift_wrap_message"
    t.integer  "promo_code_id"
    t.integer  "shipping_option_id"
    t.boolean  "gift_wrap"
    t.boolean  "keep",                 :default => false
    t.float    "credit",               :default => 0.0
    t.string   "billing_state"
    t.string   "delivery_state"
  end

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",             :default => false
    t.datetime "recycled_at"
    t.boolean  "display",              :default => true
    t.integer  "position",             :default => 0
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_alt"
    t.text     "story"
    t.string   "image_2_file_name"
    t.string   "image_2_content_type"
    t.integer  "image_2_file_size"
    t.datetime "image_2_updated_at"
    t.string   "image_2_alt"
  end

  create_table "documents", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "document_content_type"
    t.string   "document_file_name"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  create_table "donation_pages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.text     "summary"
    t.float    "admin_contribution"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",           :default => false
    t.datetime "recycled_at"
    t.boolean  "display",            :default => true
    t.integer  "position",           :default => 0
    t.string   "name"
    t.date     "target_date"
  end

  create_table "donations", :force => true do |t|
    t.integer  "order_item_id"
    t.integer  "donation_page_id"
    t.text     "message"
    t.float    "value"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",         :default => false
    t.datetime "recycled_at"
    t.boolean  "display",          :default => true
    t.integer  "position",         :default => 0
    t.boolean  "secret"
  end

  create_table "faqs", :force => true do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",    :default => false
    t.datetime "recycled_at"
    t.boolean  "display",     :default => true
    t.integer  "position",    :default => 0
  end

  create_table "features", :force => true do |t|
    t.string   "name"
    t.string   "controller"
    t.string   "action"
    t.integer  "position",         :default => 0
    t.boolean  "super_admin_only", :default => false
    t.string   "css_class"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "menu",             :default => true
    t.boolean  "permission",       :default => true
    t.string   "location"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",         :default => false
    t.datetime "recycled_at"
    t.boolean  "display",          :default => true
  end

  create_table "features_roles", :id => false, :force => true do |t|
    t.integer "feature_id"
    t.integer "role_id"
  end

  create_table "glossary_items", :force => true do |t|
    t.string   "word"
    t.text     "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "image_content_type"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "newsletter_subscribers", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",    :default => false
    t.datetime "recycled_at"
    t.boolean  "display",     :default => true
    t.integer  "position",    :default => 0
  end

  create_table "order_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "amount"
    t.float    "subtotal",        :default => 0.0
    t.string   "product_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",        :default => false
    t.datetime "recycled_at"
    t.boolean  "display",         :default => true
    t.integer  "position",        :default => 0
    t.integer  "order_item_type", :default => 0
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.float    "value",           :default => 0.0
    t.string   "delivery_type"
    t.string   "code"
    t.integer  "used_user"
    t.integer  "target_id"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.float    "delivery_subtotal",     :default => 0.0
    t.float    "discount_subtotal",     :default => 0.0
    t.float    "products_subtotal",     :default => 0.0
    t.float    "total",                 :default => 0.0
    t.string   "delivery_summary"
    t.string   "billing_surname"
    t.string   "billing_first_names"
    t.string   "billing_address_1"
    t.string   "billing_address_2"
    t.string   "billing_city"
    t.string   "billing_postcode"
    t.string   "billing_country"
    t.string   "delivery_surname"
    t.string   "delivery_first_names"
    t.string   "delivery_address_1"
    t.string   "delivery_address_2"
    t.string   "delivery_city"
    t.string   "delivery_postcode"
    t.string   "delivery_country"
    t.string   "user_email"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",              :default => false
    t.datetime "recycled_at"
    t.boolean  "display",               :default => true
    t.integer  "position",              :default => 0
    t.string   "online_invoice_number"
    t.float    "gift_wrap_subtotal",    :default => 0.0
    t.text     "gift_wrap_message"
    t.text     "gateway_reply"
    t.boolean  "gift_wrap"
    t.float    "credit"
    t.integer  "basket_id"
  end

  create_table "page_contents", :force => true do |t|
    t.string   "navigation_title"
    t.string   "url_title"
    t.string   "title"
    t.integer  "page_node_id"
    t.boolean  "completed",               :default => false
    t.boolean  "published",               :default => false
    t.boolean  "active",                  :default => false
    t.datetime "last_updated_at",         :default => '2010-04-29 08:55:42'
    t.text     "main_content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "meta_description"
    t.text     "meta_tags"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",                :default => false
    t.datetime "recycled_at"
    t.boolean  "display",                 :default => true
    t.integer  "position",                :default => 0
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_alt"
    t.text     "introduction"
    t.text     "be_part_of_it_content_1"
    t.text     "be_part_of_it_content_2"
    t.text     "be_part_of_it_content_3"
    t.text     "be_part_of_it_content_4"
    t.text     "be_part_of_it_content_5"
    t.text     "be_part_of_it_content_6"
    t.integer  "brand_id"
    t.string   "designer"
    t.string   "company"
  end

  create_table "page_nodes", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "parent_id"
    t.integer  "position",              :default => 0
    t.string   "action"
    t.string   "controller"
    t.string   "model"
    t.string   "layout"
    t.boolean  "display",               :default => false
    t.boolean  "display_in_navigation", :default => true
    t.boolean  "can_be_moved",          :default => true
    t.boolean  "can_be_edited",         :default => true
    t.boolean  "can_be_deleted",        :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_key"
    t.string   "stylesheet"
    t.boolean  "can_have_children",     :default => true
    t.boolean  "special_menu",          :default => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",              :default => false
    t.datetime "recycled_at"
  end

  create_table "price_ranges", :force => true do |t|
    t.float    "start",       :default => 0.0
    t.float    "end",         :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",    :default => false
    t.datetime "recycled_at"
    t.boolean  "display",     :default => true
    t.integer  "position",    :default => 0
  end

  create_table "product_associations", :id => false, :force => true do |t|
    t.integer "first_product_id"
    t.integer "second_product_id"
  end

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",           :default => false
    t.datetime "recycled_at"
    t.boolean  "display",            :default => true
    t.integer  "position",           :default => 0
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_alt"
  end

  create_table "product_pictures", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",    :default => false
    t.datetime "recycled_at"
    t.boolean  "display",     :default => true
    t.integer  "position",    :default => 0
  end

  create_table "product_stories", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",    :default => false
    t.datetime "recycled_at"
    t.boolean  "display",     :default => true
    t.integer  "position",    :default => 0
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.text     "description"
    t.float    "price"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",      :default => false
    t.datetime "recycled_at"
    t.boolean  "display",       :default => true
    t.integer  "position",      :default => 0
    t.boolean  "fair_trade",    :default => false
    t.boolean  "upcycled",      :default => false
    t.integer  "brand_id"
    t.text     "stock_message"
    t.text     "size"
    t.boolean  "men",           :default => true
    t.boolean  "women",         :default => true
    t.string   "product_code"
    t.float    "sale_price"
    t.boolean  "sale"
    t.string   "cached_slug"
    t.boolean  "new_in",        :default => false
  end

  create_table "products_product_stories", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "product_story_id"
  end

  create_table "products_promo_codes", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "promo_code_id"
  end

  create_table "promo_codes", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.date     "start_date",      :default => '2010-11-01'
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",        :default => false
    t.datetime "recycled_at"
    t.boolean  "display",         :default => true
    t.integer  "position",        :default => 0
    t.string   "promo_code_type"
    t.float    "amount_off"
    t.integer  "percentage_off"
    t.float    "minimum_amount"
  end

  create_table "promo_codes_shipping_options", :id => false, :force => true do |t|
    t.integer "promo_code_id"
    t.integer "shipping_option_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.boolean  "all_features", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",     :default => false
    t.datetime "recycled_at"
    t.boolean  "display",      :default => true
  end

  create_table "shipping_options", :force => true do |t|
    t.string   "name"
    t.float    "price"
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",    :default => false
    t.datetime "recycled_at"
    t.boolean  "display",     :default => true
    t.integer  "position",    :default => 0
  end

  create_table "site_settings", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.boolean  "super_admin_only", :default => true
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",         :default => false
    t.datetime "recycled_at"
    t.boolean  "display",          :default => true
    t.string   "input_type",       :default => "text_area"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "spotlights", :force => true do |t|
    t.string   "designer"
    t.string   "company"
    t.text     "summary"
    t.text     "content"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",           :default => false
    t.datetime "recycled_at"
    t.boolean  "display",            :default => true
    t.integer  "position",           :default => 0
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_alt"
    t.boolean  "highlight",          :default => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "testimonials", :force => true do |t|
    t.string   "writer"
    t.text     "statement"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",    :default => false
    t.datetime "recycled_at"
    t.boolean  "display",     :default => true
    t.integer  "position",    :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "last_login_at"
    t.string   "perishable_token",  :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "recycled",          :default => false
    t.datetime "recycled_at"
    t.boolean  "display",           :default => true
    t.integer  "position",          :default => 0
    t.string   "first_names"
    t.string   "surname"
    t.float    "credit",            :default => 0.0
    t.boolean  "redeem_disabled"
  end

end
