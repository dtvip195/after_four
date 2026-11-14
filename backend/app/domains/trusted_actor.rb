class TrustedActor
  UUID_FORMAT = /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i

  def self.require_id!(actor_id)
    return actor_id if actor_id.to_s.match?(UUID_FORMAT)

    raise DomainError.new("trusted_actor_required", "A trusted actor context is required")
  end
end
