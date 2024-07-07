# frozen_string_literal: true

require 'fog/core/model'

module Fog
  module DNS
    class PowerDNS
      class Zone < Fog::Model
        identity :zone_id

        attribute :zone, aliases: 'name'
        attribute :kind
        attribute :server_id

        DEFAULT_SERVER = 'localhost'

        def destroy
          service.delete_zone(identity)
          true
        end

        def records
          # TODO: Should rewrite this
          @records ||= begin
            Fog::DNS::PowerDNS::Records.new(
              zone: self,
              service: service
            )
          end
        end

        def save
          requires :zone, :kind
          data = service.create_zone(DEFAULT_SERVER, zone, kind)
          merge_attributes(data)
          true
        end
      end
    end
  end
end
