shared_examples_for 'success get action' do
  before do
    get action
  end
  it { expect(response).to have_http_status :cuccess }
end
