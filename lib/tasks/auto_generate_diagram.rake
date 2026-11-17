# NOTE: only doing this in development as some production environments (Heroku)
# NOTE: are sensitive to local FS writes, and besides -- it's just not proper
# NOTE: to have a dev-mode tool do its thing in production.
if defined? RailsERD
  RailsERD.load_tasks
end

if Rails.env.development?
  begin
    # Регистрируем автоматическое обновление схемы Mermaid
    Rake::Task["db:migrate"].enhance do
      puts "🔄 Обновление ERD схемы базы данных..."
      system("bundle exec rails mermaid_erd")
    end
  rescue => e
    # Безопасный пропуск, если что-то пойдет не так
  end
end