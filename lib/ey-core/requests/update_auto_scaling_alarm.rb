class Ey::Core::Client
  class Real
    def update_auto_scaling_alarm(params = {})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/auto_scaling_alarms/#{id}",
        :body   => { "auto_scaling_alarm" => params.fetch("auto_scaling_alarm") },
      )
    end
  end

  class Mock
    def update_auto_scaling_alarm(params = {})
      resource_id = params.delete("id")
      now = Time.now
      resource = find(:auto_scaling_alarms, resource_id)
        .merge(params["auto_scaling_alarm"])
        .merge("updated_at" => now)
      resource.merge!(params)

      request = {
        "id"           => self.uuid,
        "type"         => "update_auto_scaling_alarm",
        "successful"   => true,
        "created_at"   => now - 5,
        "started_at"   => now - 3,
        "finished_at"  => now,
        "updated_at"   => now,
        "message"      => nil,
        "read_channel" => nil,
        "resource"     => [:auto_scaling_alarms, resource_id, resource],
        "resource_url" => url_for("/auto_scaling_alarms/#{resource_id}")
      }

      self.data[:requests][request["id"]] = request

      response(
        body:   { "request" => request },
        status: 200
      )
    end
  end
end
