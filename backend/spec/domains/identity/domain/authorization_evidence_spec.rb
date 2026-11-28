require "rails_helper"

RSpec.describe "Identity authorization evidence" do
  let(:assignment_class) { Identity::Domain::Entities::RoleAssignment }
  let(:link_class) { Identity::Domain::Entities::UserEmployeeLink }
  let(:role_code) { Identity::Domain::ValueObjects::RoleCode::STAFF }
  let(:effective_from) { Time.utc(2026, 11, 28, 1, 0, 0) }
  let(:effective_until) { Time.utc(2026, 11, 28, 2, 0, 0) }

  describe "RoleAssignment" do
    it "is immutable and applies a half-open effective interval" do
      assignment = assignment_class.new(
        id: uuid(1),
        user_id: uuid(2),
        organization_id: uuid(3),
        branch_id: uuid(4),
        role_code: role_code,
        effective_from: effective_from,
        effective_until: effective_until
      )

      expect(assignment).to be_frozen
      expect(assignment.effective_at?(effective_from)).to be(true)
      expect(assignment.effective_at?(effective_until - 0.000001)).to be(true)
      expect(assignment.effective_at?(effective_until)).to be(false)
      expect(assignment.effective_at?(effective_from - 0.000001)).to be(false)
      expect(assignment.role_code).to equal(role_code)
    end

    it "requires Organization scope for Owner and exact Branch scope for non-Owner roles" do
      owner = assignment_class.new(
        id: uuid(1), user_id: uuid(2), organization_id: uuid(3), branch_id: nil,
        role_code: Identity::Domain::ValueObjects::RoleCode::OWNER,
        effective_from: effective_from, effective_until: nil
      )

      expect(owner.organization_scoped?).to be(true)
      expect(owner.branch_scoped?).to be(false)

      expect do
        assignment_class.new(
          id: uuid(1), user_id: uuid(2), organization_id: uuid(3), branch_id: uuid(4),
          role_code: Identity::Domain::ValueObjects::RoleCode::OWNER,
          effective_from: effective_from, effective_until: nil
        )
      end.to raise_error(ArgumentError, "Owner assignment must be Organization-scoped")

      expect do
        assignment_class.new(
          id: uuid(1), user_id: uuid(2), organization_id: uuid(3), branch_id: nil,
          role_code: Identity::Domain::ValueObjects::RoleCode::STAFF,
          effective_from: effective_from, effective_until: nil
        )
      end.to raise_error(ArgumentError, "non-Owner assignment must be Branch-scoped")
    end

    it "rejects invalid identifiers, role impersonation, and invalid intervals" do
      valid = {
        id: uuid(1), user_id: uuid(2), organization_id: uuid(3), branch_id: uuid(4),
        role_code: role_code, effective_from: effective_from, effective_until: effective_until
      }

      expect { assignment_class.new(**valid.merge(id: "not-a-uuid")) }.to raise_error(ArgumentError)
      expect { assignment_class.new(**valid.merge(role_code: role_code.value)) }.to raise_error(ArgumentError)
      expect do
        assignment_class.new(**valid.merge(effective_until: effective_from))
      end.to raise_error(ArgumentError, "effective_until must be after effective_from")
      expect { assignment_class.new(**valid).effective_at?("now") }.to raise_error(ArgumentError)
    end
  end

  describe "UserEmployeeLink" do
    it "is immutable and applies the same half-open effective interval" do
      link = link_class.new(
        id: uuid(1),
        user_id: uuid(2),
        employee_id: uuid(3),
        organization_id: uuid(4),
        effective_from: effective_from,
        effective_until: effective_until
      )

      expect(link).to be_frozen
      expect(link.effective_at?(effective_from)).to be(true)
      expect(link.effective_at?(effective_until - 0.000001)).to be(true)
      expect(link.effective_at?(effective_until)).to be(false)
      expect(link.effective_at?(effective_from - 0.000001)).to be(false)
    end

    it "rejects malformed identifiers and invalid intervals without defining relink policy" do
      valid = {
        id: uuid(1), user_id: uuid(2), employee_id: uuid(3), organization_id: uuid(4),
        effective_from: effective_from, effective_until: effective_until
      }

      expect { link_class.new(**valid.merge(employee_id: "not-a-uuid")) }.to raise_error(ArgumentError)
      expect do
        link_class.new(**valid.merge(effective_until: effective_from))
      end.to raise_error(ArgumentError, "effective_until must be after effective_from")
      expect { link_class.new(**valid).effective_at?(nil) }.to raise_error(ArgumentError)
    end
  end

  def uuid(number)
    format("%08d-0000-0000-0000-%012d", number, number)
  end
end
