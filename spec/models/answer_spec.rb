require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should belong_to(:question) }
  it { should have_db_index(:question_id) }
  it { should belong_to(:user) }
  it { should have_many(:attachments) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it_behaves_like "votable"

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

  describe '#get_attachments' do
    let(:answer) { create(:answer) }
    let!(:attachment) { create(:attachment, attachable: answer) }

    it 'Get attachments filename and url to hash' do
      puts answer.get_attachments
      expect(answer.get_attachments[0]).to include(filename: attachment.file.identifier, url: attachment.file.url)
    end
  end
end
