# Run: ruby bin/rails runner scripts/check_video_learning.rb
# Uses a verified local user and rolls back all test records and role changes.
abort 'Run only against a local development database.' unless Rails.env.development?
require 'warden/test/helpers'
include Warden::Test::Helpers
Warden.test_mode!
ActiveRecord::Base.transaction do
  user = User.where(email_verify_flg: true, comp_id: nil).first!
  user.update_columns(access_type: User::ACCESS_TYPE::KANRISHA)
  RecordWithOperator.operator = user
  root = VideoGenre.create!(title: 'Test course')
  child = VideoGenre.create!(title: 'Test chapter', video_genre: root)
  raise 'Third category level accepted' if VideoGenre.new(title: 'Invalid', video_genre: child).valid?
  root.video_genre = child
  raise 'Category cycle accepted' if root.valid?
  root.reload
  cues = [{ 'start' => 1.0, 'end' => 2.0, 'text' => 'Hello' }]
  lesson = VideoLesson.create!(title: 'Test published video', user: user, video_genre: child, youtube_video_id: 'M7lc1UVf-VE', subtitle_cues: cues, hide_flg: false)
  draft = VideoLesson.create!(title: 'Test draft', user: user, youtube_video_id: 'M7lc1UVf-VE', subtitle_cues: cues)
  raise 'Published video missing' unless VideoLesson.visible_to(user).exists?(lesson.id)
  raise 'Draft exposed' if VideoLesson.visible_to(user).exists?(draft.id)
  root.update!(hide_flg: true)
  raise 'Hidden parent exposes lessons' if VideoLesson.visible_to(user).exists?(lesson.id)
  root.update!(hide_flg: false)
  client = ActionDispatch::Integration::Session.new(Rails.application)
  client.host! 'localhost'
  login_as(user, scope: :user)
  paths = ['/admin/video_genres', '/admin/video_genres/new', "/admin/video_genres/#{root.id}", "/admin/video_genres/#{child.id}/edit", '/admin/video_lessons', '/admin/video_lessons/new', "/admin/video_lessons/#{lesson.id}", "/admin/video_lessons/#{lesson.id}/edit", '/admin/video_lessons/youtube_import', '/video_lessons', "/video_lessons/#{lesson.id}"]
  paths.each do |path|
    client.get(path)
    raise "Rendering failed #{path}: #{client.response.status}" unless client.response.status == 200
  end
  raise 'Study contains admin actions' if Nokogiri::HTML(client.response.body).at_css('[data-video-lesson]').to_html.include?('data-method="delete"')
  client.get('/video_lessons', params: { genre_id: root.id, q: 'Test published' })
  raise 'Category search failed' unless client.response.status == 200 && client.response.body.include?('Test published video')
  client.get("/admin/video_lessons/#{lesson.id}/edit")
  csrf = Nokogiri::HTML(client.response.body).at_css('meta[name=csrf-token]')['content']
  client.patch("/admin/video_lessons/#{lesson.id}", params: { video_lesson: { title: lesson.title, video_genre_id: child.id, hide_flg: '0', sort: '2', content: 'Study description' } }, headers: { 'X-CSRF-Token' => csrf })
  raise 'Manager update failed' unless client.response.status == 302 && lesson.reload.content == 'Study description'
  client.post('/admin/video_genres', params: { video_genre: { title: 'Created through form', video_genre_id: root.id, sort: '3' } }, headers: { 'X-CSRF-Token' => csrf })
  raise 'Manager category creation failed' unless client.response.status == 302
  user.update_columns(access_type: User::ACCESS_TYPE::USER)
  student = ActionDispatch::Integration::Session.new(Rails.application)
  student.host! 'localhost'
  login_as(user.reload, scope: :user)
  ['/admin/video_genres', '/admin/video_lessons', '/admin/video_lessons/new', '/youtube/callback'].each do |path|
    student.get(path)
    raise "Student can access #{path}" unless student.response.status == 403
  end
  student.get('/video_lessons')
  raise 'Student cannot study' unless student.response.status == 200
  student.get("/video_lessons/#{draft.id}")
  raise 'Student can open draft directly' unless student.response.status == 404
  # Different channel content must not appear in public study scope.
  channel = Channel.first
  if channel
    private_genre = VideoGenre.create!(title: 'Private category', channel: channel)
    private_lesson = VideoLesson.create!(title: 'Private lesson', user: user, channel: channel, video_genre: private_genre, youtube_video_id: 'M7lc1UVf-VE', subtitle_cues: cues, hide_flg: false)
    raise 'Channel content exposed' if VideoLesson.visible_to(user).exists?(private_lesson.id)
  end
  root.destroy!
  raise 'Category removal leaves visible lesson' if VideoLesson.visible_to(user).exists?(lesson.id)
  raise 'Soft deletion lost original lesson' unless VideoLesson.with_deleted.exists?(lesson.id)
  puts 'PASS: 11 pages, study search, hierarchy/cycle validation, drafts, ancestor visibility, student restrictions, channel isolation, soft deletion. All data rolled back.'
  raise ActiveRecord::Rollback
end
Warden.test_reset!
