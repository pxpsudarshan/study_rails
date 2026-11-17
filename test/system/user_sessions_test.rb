# frozen_string_literal: true

require "application_system_test_case"

class UserSessionsTest < ApplicationSystemTestCase
  setup do
    RecordWithOperator::Current.reset

    system_user = User.order(:created_at).first || begin
      sys_id = SecureRandom.uuid
      u = User.new(
        id: sys_id,
        email: "system@example.com",
        password: "Password123",
        sei: 'Admin',
        mei: 'User',
        login_flg: true,
        email_verify_flg: true,
        created_by: sys_id,
        updated_by: sys_id
      )
      u.save!(validate: false)
      u
    end

    RecordWithOperator.with_operator(system_user) do
      @active_user = User.create!(
        email: "active@example.com",
        password: "Password123",
        sei: 'Active',
        mei: 'User',
        login_flg: true,
        email_verify_flg: true
      )

      @blocked_user = User.create!(
        email: "blocked@example.com",
        password: "Password123",
        sei: 'Blocked',
        mei: 'User',
        email_verify_flg: true
      )
      @blocked_user.update_column(:login_flg, false)

      @active_comp = Comp.create!(
        email: "comp_active@example.com",
        password: "Password123",
        sei: 'Active',
        mei: 'Company',
        sei_kana: 'Active',
        mei_kana: 'Company',
        mobile: '012345678',
        company_name: 'Test Company',
        business_type: 'Engineer',
        department: 'IT',
        login_flg: true
      )

      @blocked_comp = Comp.create!(
        email: "comp_blocked@example.com",
        password: "Password123",
        sei: 'Blocked',
        mei: 'Company',
        sei_kana: 'Blocked',
        mei_kana: 'Company',
        mobile: '012345678',
        company_name: 'Test Company',
        business_type: 'Engineer',
        department: 'IT',
      )
      @blocked_comp.update_column(:login_flg, false)
    end
  end

  # --- Тесты для User ---

  test "allows active user to sign in and creates syslog entry" do
    visit new_user_session_path

    fill_in "user_email", with: @active_user.email
    fill_in "user_password", with: "Password123"
    find('input[type="submit"], button[type="submit"]').click

    assert_current_path menus_path

    log = Syslog.order(:created_at).last
    assert_not_nil log
    assert_includes log.context, @active_user.email
    assert_equal @active_user.id, log.created_by
  end

  test "prevents user sign in when login_flg is false" do
    initial_log_count = Syslog.count

    visit new_user_session_path

    fill_in "user_email", with: @blocked_user.email
    fill_in "user_password", with: "Password123"
    find('input[type="submit"], button[type="submit"]').click

    assert_current_path new_user_session_path
    assert_equal initial_log_count, Syslog.count
  end

  test "shows error with invalid user password" do
    visit new_user_session_path

    fill_in "user_email", with: @active_user.email
    fill_in "user_password", with: "wrong_password"
    find('input[type="submit"], button[type="submit"]').click

    assert_current_path new_user_session_path
  end

  # --- Тесты для Comp ---

  test "allows active comp to sign in and creates syslog entry" do
    visit new_comp_session_path

    fill_in "comp_email", with: @active_comp.email
    fill_in "comp_password", with: "Password123"
    find('input[type="submit"], button[type="submit"]').click

    assert_current_path kaisha_menus_path

    log = Syslog.order(:created_at).last
    assert_not_nil log
    assert_includes log.context, @active_comp.email
    assert_equal @active_comp.id, log.created_by
  end

  test "prevents comp sign in when login_flg is false" do
    initial_log_count = Syslog.count

    visit new_comp_session_path

    fill_in "comp_email", with: @blocked_comp.email
    fill_in "comp_password", with: "Password123"
    find('input[type="submit"], button[type="submit"]').click

    assert_current_path new_comp_session_path
    assert_equal initial_log_count, Syslog.count
  end

  test "signs out active user when comp signs in" do
    # 1. Сначала входим как User
    visit new_user_session_path
    fill_in "user_email", with: @active_user.email
    fill_in "user_password", with: "Password123"
    find('input[type="submit"], button[type="submit"]').click
    assert_current_path menus_path

    # 2. Затем входим как Comp в той же сессии
    visit new_comp_session_path
    fill_in "comp_email", with: @active_comp.email
    fill_in "comp_password", with: "Password123"
    find('input[type="submit"], button[type="submit"]').click
    assert_current_path kaisha_menus_path
  end
end
