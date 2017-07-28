require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should belong_to(:question) }
  it { should have_db_index(:question_id) }
  it { should belong_to(:user) }

  describe '#toggle_best!' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let!(:another_answer) { create(:answer, question: question, best: :true) }

    it 'Choose best answer' do
      expect(answer.toggle_best!).to eq true
    end

    it 'Another answer become not best' do
      expect(answer.toggle_best!).to eq true
      another_answer.reload
      expect(another_answer.best).to eq false
    end
  end
end
