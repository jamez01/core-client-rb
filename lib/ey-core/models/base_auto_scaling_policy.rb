class Ey::Core::Client::BaseAutoScalingPolicy < Ey::Core::Model
  extend Ey::Core::Associations

  identity :id, type: :integer

  attribute :provisioned_id
  attribute :provisioner_id
  attribute :type
  attribute :name
  attribute :configuration
  attribute :auto_scaling_group_id

  has_one :auto_scaling_group

  def save!
    requires :auto_scaling_group_id
    params = {
      "url"                 => self.collection.url,
      "auto_scaling_policy" => {
        "name" => self.name
      }.merge(policy_params),
      "auto_scaling_group"  => self.auto_scaling_group_id
    }

    if new_record?
      policy_requires
      requires :name
      connection.requests.new(connection.create_auto_scaling_group(params).body["auto_scaling_policy"])
    else
      requires :identity
      params.merge("id" => identity)
      connection.requests.new(connection.update_auto_scaling_policy(params).body["auto_scaling_policy"])
    end
  end

  private

  def policy_params
    raise NotImplementedError
  end

  def policy_requires
    raise NotImplementedError
  end
end
