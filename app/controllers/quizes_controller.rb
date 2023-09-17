class QuizesController < ApplicationController
  def index
    @current_user_quiz = current_user.id

    # @quizData = VocabStore.select("vocab_stores.vocab_read, vocab_stores.vocab_code, vocab_stores.nation_vocab, vocab_stores.vocab_org")
    #   .joins(:vocab_mycards)
    #   .select("vocab_stores.vocab_read, vocab_stores.vocab_code, vocab_stores.nation_vocab")
    #   .where("vocab_mycards.vocab_org = vocab_stores.vocab_org")
    #   .where("vocab_mycards.user_id = ?", @current_user_quiz)
    #   .shuffle

    @quizData = current_user.vocab_mycards.joins(:vocab_store).shuffle
    # b.each do |number|
    #   related_mycard = number.vocab_store.nation_vocab
    #   puts "No related_vocab_mycard found for mycard with ID #{related_mycard}"

      # if related_mycard.present?
      #   # Now you can access attributes of the related record
      #   vocab_read = related_mycard.vocab_read
      #   vocab_code = related_mycard.vocab_code
      #   nation_vocab = related_mycard.nation_vocab
      #
      #   # Use the values as needed
      #   puts "Vocab Read: #{vocab_read}, Vocab Code: #{vocab_code}, Nation Vocab: #{nation_vocab}"
      # else
      #   # Handle the case where there is no related record
      #   puts "No related_vocab_mycard found for mycard with ID #{mycard.id}"
      # end
      # Inside the loop, you can perform actions for each element
      # puts "Processing number: #{number.vocab_code}"

      # You can also perform database operations, calculations, or other tasks
      # For example, you might save each number to the database:
      # MyModel.create(value: number)
    # end
    # puts "Hello, #{b[1].created_at}"
    # puts "Hello_count, #{b.count}"
    @total_count = @quizData.count

  end

  def next_ques
    vocab_org = params[:vocab_org]
    mycard_level = params[:mycard_level]

    # Find and update all records (including soft-deleted ones) that match the condition
    @questionUpdate = VocabMycard.unscoped.where(vocab_org: vocab_org, user_id: current_user.id).update_all(mycard_level: mycard_level)

  end
end
