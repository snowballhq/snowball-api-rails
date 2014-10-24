module Orderable
  extend ActiveSupport::Concern

  included do
    default_scope { order('created_at') }
  end
end
