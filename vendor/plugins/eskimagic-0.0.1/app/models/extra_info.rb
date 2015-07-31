class ExtraInfo < ActiveRecord::Base
  
  belongs_to :extra_infoable, :polymorphic => true
  
end
