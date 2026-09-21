module SidebarHelper
  def admin_content?
    controller_path.start_with?('admin/') || %w(kaisha/comps kaisha/users kaisha/progress).include?(controller_path)
  end

  def show_app_sidebar?
    (current_user.present? || current_comp.present?) && controller_name != 'mains' && action_name != 'new_user'
  end

  def sidebar_groups
    if current_comp.present?
      groups = [[t('sidebar.recruitment'), [
        ['sidebar.dashboard', kaisha_menus_path, 'home'], ['navbar.offer', kaisha_offers_path, 'search'],
        ['navbar.job_profile', kaisha_job_profiles_path, 'briefcase'], ['navbar.company_store', new_kaisha_company_store_path, 'book']
      ]]]
      management = [['navbar.user', kaisha_users_path, 'users'], ['navbar.progress', kaisha_progress_index_path, 'chart-line']]
      management.unshift(['navbar.comp', kaisha_comps_path, 'building']) if current_comp.access_type != Comp::ACCESS_TYPE::OTHER
      groups << [strip_tags(t('navbar.master')), management]
    else
      groups = [[t('sidebar.learn'), [
        ['sidebar.dashboard', menus_path, 'home'], ['feature.vocab_hiragana', gois_path, 'book'],
        ['feature.vocab_native', foreigns_path, 'language'], ['feature.kanji', kanjis_path, 'font'],
        ['feature.parts', parts_path, 'puzzle-piece'], ['feature.mycard', vocab_mycards_path, 'clone'],
        ['feature.quiz', quizes_path, 'question-circle']
      ]], [t('sidebar.track'), [['sidebar.progress', charts_path, 'chart-line']]],
        [t('sidebar.career'), [['navbar.job', jobs_path, 'briefcase'], ['navbar.store', new_store_path, 'book-open'], ['navbar.profile', profile_user_path(current_user), 'user']]]]
      if current_user.access_type != User::ACCESS_TYPE::USER
        management = [['navbar.vocab_table', admin_vocab_tables_path, 'book'], ['navbar.audio_a', admin_audio_as_path, 'comments'], ['navbar.tokutei', admin_tokuteis_path, 'tasks']]
        if current_user.access_type == User::ACCESS_TYPE::KANRISHA
          management.unshift(['navbar.vocab_genre', admin_vocab_genres_path, 'tags'])
          unless current_user.comp&.channel_id.present?
            management.unshift(['navbar.channel', admin_channels_path, 'broadcast-tower'], ['navbar.block_ip', admin_block_ips_path, 'ban'], ['navbar.parts_table', admin_parts_tables_path, 'puzzle-piece'], ['navbar.kanji_table', admin_kanji_tables_path, 'font'])
          end
        end
        groups << [strip_tags(t('navbar.master')), management]
      end
    end
    groups
  end

  def sidebar_link(label, path, icon, method: :get)
    # Match nested actions as well as the collection page, without matching sibling controllers.
    base = path.sub(%r{/new\z}, '')
    active = request.path == path || request.path == base || request.path.start_with?("#{base}/")
    active ||= request.path == root_path && path == menus_path
    label = strip_tags(t(label)).strip
    active = false unless method == :get
    content = content_tag(:i, '', class: "fas fa-#{icon} fa-fw", aria: { hidden: true }) + content_tag(:span, label)
    link_to content, path, class: "nav-link d-flex align-items-center gap-3 rounded-0 px-3 py-2 mb-1#{' active' if active}", method: method, title: label, aria: { label: label, current: ('page' if active) }
  end
end
