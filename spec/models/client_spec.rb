require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:com_name) { Faker::Company.name }
  let(:logo) { File.open(File.join(Rails.root, 'spec/fixtures/images/lobo.png')) }
  let(:com_url) { 'http://example.com' }
  let(:clientname) { 'examplename' }
  let(:location) { '02' }
  let(:client) { Client.create(name: com_name, corporate_site: com_url, clientname: clientname, location: location, logo: logo) }

  context 'validates' do
    context 'successful' do
      it { expect(client).to be_valid }
    end

    context 'failed' do
      context 'corporate_site' do
        context 'present' do
          let(:com_url) { '' }
          it { expect(client).to be_invalid }
        end

        context 'unique' do
          let(:duplicate_client) { client.dup }
          before do
            duplicate_client.corporate_site = client.corporate_site
            client.save
          end
          it { expect(duplicate_client).to be_invalid }
        end

        context 'format' do
          let(:invalid_urls) { ['//http://exmaple.com', 'httP:example.com', 'httpr://example.com', 'http;//example.com'] }
          it 'should failed validate' do
            invalid_urls.each do |url|
              client.corporate_site = url
              expect(client).to be_invalid
            end
          end
        end
      end

      context 'name' do
        context 'present' do
          let(:com_name) { '' }
          it { expect(client).to be_invalid }
        end

        context 'minimum' do
          let(:com_name) { 'a' }
          it { expect(client).to be_invalid }
        end
      end

      context 'clientname' do
        context 'present' do
          let(:com_name) { '' }
          it { expect(client).to be_invalid }
        end

        context 'unique' do
          let(:duplicate_client) { client.dup }
          before do
            duplicate_client.clientname = client.clientname
            client.save
          end
          it { expect(duplicate_client).to be_invalid }
        end

        context 'format' do
          let(:invalid_clientnames) { ['AA000', 'aa-bbb', 'aaaaa+b', 'aa.00', '///', 'a' * 31] }
          it 'should be invalid' do
            invalid_clientnames.each do |invalid_clientname|
              client.clientname = invalid_clientname
              expect(client).to be_invalid
            end
          end
        end

        context 'minimum' do
          let(:com_name) { 'a' }
          it { expect(client).to be_invalid }
        end
      end

      context 'location' do
        let(:location) { '' }
        it { expect(client).to be_invalid }
      end

      context 'logo' do
        let(:logo) { '' }
        it { expect(client).to be_invalid }
      end
    end
  end
end
