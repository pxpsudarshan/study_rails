# frozen_string_literal: true

require "test_helper"

class RecordWithOperatorTest < ActiveSupport::TestCase
  setup do
    RecordWithOperator::Current.reset
    system_user = User.first || begin
      sys_id = SecureRandom.uuid
      user = User.new(
        id: sys_id,
        email: "system@example.com",
        password: "Password123",
        sei: 'Admin',
        mei: 'User',
        created_by: sys_id,
        updated_by: sys_id
      )
      user.save!(validate: false)
      user
    end
    RecordWithOperator.with_operator(system_user) do
      @alice = User.create!(email: "alice@example.com", password: "Password123", sei: 'Alice', mei: 'Jiro')
      @bob = User.create!(email: "bob@example.com", password: "Password123", sei: 'Bob', mei: 'Taro')
    end
  end

  teardown do
    RecordWithOperator::Current.reset
  end

  test "sets creator on create" do
    post = RecordWithOperator.with_operator(@alice) do
      Syslog.create!(context: "Hello")
    end

    assert_equal @alice.id, post.created_by
    assert_equal @alice, post.creator
    assert_equal @alice.id, post.updated_by
    assert_equal @alice, post.updater
  end

  test "sets updater only when record changes" do
    post = RecordWithOperator.with_operator(@alice) do
      Syslog.create!(context: "Hello")
    end

    RecordWithOperator.with_operator(@bob) do
      post.save!
      assert_equal @alice.id, post.updated_by

      post.update!(context: "Updated")
    end

    assert_equal @bob.id, post.updated_by
    assert_equal @bob, post.updater
    assert_equal @alice.id, post.created_by
  end

  test "sets deleter on destroy" do
    post = RecordWithOperator.with_operator(@alice) do
      Syslog.create!(context: "To be deleted")
    end

    RecordWithOperator.with_operator(@bob) do
      post.destroy!
    end

    assert_equal @bob.id, post.deleted_by
    assert_equal @bob, post.deleter
  end

  test "uses default user from DB when current operator is not set" do
    system_user = User.order(:created_at).first
    post = Syslog.new(context: "System post")

    assert post.valid?
    assert_equal system_user.id, post.created_by
    assert_equal system_user.id, post.updated_by
    assert_equal system_user, post.creator
  end

#  test "prevents creation without operator" do
#    post = Syslog.new(context: "System post")

#    assert_not post.valid?
#    assert_includes post.errors.attribute_names, :creator

#    assert_raises(ActiveRecord::RecordInvalid) do
#      post.save!
#    end
#  end
end
