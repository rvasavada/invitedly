class ResponseType < ActiveRecord::Base
  default_scope order('name ASC')
end
