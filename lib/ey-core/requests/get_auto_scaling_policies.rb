class Ey::Core::Client
  class Real
    def get_auto_scale_policies(params = {})
      query = Ey::Core.paging_parameters(params)
      url   = params.delete("url")

      request(
        :params => params,
        :path   => "/auto_scaling_policies",
        :query  => params,
        :url    => url,
      )
    end
  end

  class Mock
    def get_auto_scale_policies(params = {})
      extract_url_params!(params)
      resources = data[:auto_scaling_policies].select { |_key, policy| filter_policy(params, policy) }
      headers, auto_scaling_policies_page = search_and_page(params, :auto_scaling_policies, resources: resources)

      response(
        :body    => { "auto_scaling_policies" => auto_scaling_policies_page },
        :status  => 200,
        :headers => headers
      )
    end
  end

  private

  def filter_policy(params, item)
    if params["auto_scaling_group_id"] && !item["auto_scaling_group"]["id"] == params["auto_scaling_group_id"]
      return false
    end

    types = params["types"]
    types.is_a?(::Array) && types.include?(item["type"])
  end
end
