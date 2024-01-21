class SpecifiedQuizesController < ApplicationController
    def index
        # Assuming this code is in a controller action

        @classify_c_value = params[:classify_c]
        
        @specified_skills = SpecifiedSkill.where(classify_c: @classify_c_value).all        


        # Shuffle the specified_skills
        @SpecifiedQuizeData = @specified_skills.shuffle

        # Count the total number of shuffled records
        @total_count = @SpecifiedQuizeData.count
    
    end
    
    def next_ques
        vocab_org = params[:vocab_org]
        mycard_level = params[:mycard_level]

        # Find and update all records (including soft-deleted ones) that match the condition
        @questionUpdate = VocabMycard.unscoped.where(vocab_org: vocab_org, user_id: current_user.id).update_all(mycard_level: mycard_level)
    end
end
