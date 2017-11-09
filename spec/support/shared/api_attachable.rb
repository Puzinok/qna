shared_examples "API Attachable" do
  context 'attachments' do
    it 'included in object' do
      expect(response.body).to have_json_size(1).at_path("attachments")
    end

    %w(attachments created_at updated_at).each do |attr|
      it "object contains #{attr}" do
        expect(response.body).to be_json_eql(attachable.send(attr.to_sym).to_json).at_path(attr.to_s)
      end
    end
  end
end