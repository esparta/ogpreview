# frozen_string_literal: true

# Rails default since 5.x
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
