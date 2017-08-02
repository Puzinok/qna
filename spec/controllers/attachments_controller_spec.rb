require 'rails_helper'

RSpec.describe  AttachmentsController, type: :controller do
  context 'DELETE #destroy' do
    let(:question) { create(:question) }
    let!(:file){ create(:attachment, attachable: question) }

    context 'Non authenticate user' do
      it 'doestn delete questions attachment' do
        expect { delete :destroy, params: { id: file.id } }
        .to_not change(Attachment, :count)
      end
    end

    context 'Authenticate user' do
      sign_in_user

      it 'can not delete attachments' do
        expect { delete :destroy, params: { id: file.id }, format: :js }
        .to_not change(question.attachments, :count)
      end
    end

    context 'Author of question' do
      sign_in_user
      let(:user_question) { create(:question, user: @user)  }
      let!(:user_file){ create(:attachment, attachable: user_question) }

      it 'can delete attachments' do

        expect { delete :destroy, params: { id: user_file.id }, format: :js }
        .to change(user_question.attachments, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: user_file.id }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end