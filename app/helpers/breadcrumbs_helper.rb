module BreadcrumbsHelper
  # Only link to section landing pages that work without additional parameters.
  BREADCRUMB_SECTIONS = %w[
    gois foreigns kanjis kanji_scrolls kanji_units parts jobs vocab_mycards
    quizes specified_vocabs charts admin/parts_tables admin/kanji_tables
    admin/vocab_tables admin/vocab_genres admin/tokuteis admin/users
    admin/channels admin/block_ips admin/audio_as kaisha/comps kaisha/users
    kaisha/offers kaisha/job_profiles kaisha/progress
  ].freeze

  def breadcrumb_history_scope
    account = current_comp || current_user
    "#{account.class.name}:#{account&.id}:#{controller_path.start_with?('kaisha/') ? 'company' : 'student'}"
  end

  def breadcrumb_items
    return [] if controller_name == 'mains' || controller_name == 'menus'

    company = controller_path.start_with?('kaisha/')
    items = [[t('breadcrumbs.home'), company ? kaisha_root_path : root_path]]
    section = t("breadcrumbs.sections.#{controller_name}", default: controller_name.humanize)
    action = { 'create' => 'new', 'update' => 'edit' }.fetch(action_name, action_name)

    if action != 'index' && BREADCRUMB_SECTIONS.include?(controller_path)
      items << [section, url_for(controller: "/#{controller_path}", action: 'index', only_path: true)]
    end

    title = if action == 'index'
      section
    else
      t("page_title.#{controller_name}.#{action}",
        default: "#{section} · #{t("breadcrumbs.actions.#{action}", default: action.humanize)}")
    end
    if controller_path == 'vocab_genres' && action == 'index' && @selected_genre
      title = breadcrumb_genre_label(@root_genre, @selected_genre)
    elsif @gois.is_a?(Hash) && @gois[:vocab_code].present?
      title = @gois[:vocab_code]
    end
    items << [strip_tags(title).strip, nil]
    items
  end

  def breadcrumb_genre_title(genre)
    language = current_user&.lang_id
    translation = genre.languages.find { |item| item.language == language } unless language.blank? || language == 'JP'
    strip_tags(translation&.content.presence || genre.title).strip
  end

  def breadcrumb_genre_label(root_genre, genre)
    [root_genre, genre].uniq(&:id).map { |item| breadcrumb_genre_title(item) }.join(' › ')
  end
end
