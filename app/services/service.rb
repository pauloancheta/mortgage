module Service
  extend ActiveSupport::Concern

  included do
    include Virtus::Model

    def self.call(*args)
      new(*args).call
    end
  end
end
