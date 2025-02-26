require 'rails_helper'

RSpec.describe WhatsappService do
  describe '#send_pdf' do
    context 'when pass valid params' do
      it 'sends file' do
        filepath = 'spec/fixtures/test-documentation.pdf'
        cellphone = '5511947271100'
        content = "{\"error\":false,\"message\":\"Message sent\",\"messageData\":{\"key\":{\"remoteJid\":\"#{cellphone}@s.whatsapp.net\",\"fromMe\":true,\"id\":\"3EB001F1DCE595DBAB43E0\"},\"message\":{\"documentMessage\":{\"url\":\"https://mmg.whatsapp.net/v/t62.7119-24/40771768_2112715075856499_399986930701391294_n.enc?ccb=11-4&oh=01_Q5AaIPeh8RjG_yPf0IvODqhrdonYbcTpJDOsOgd7IW9rLqPu&oe=67E6FFE7&_nc_sid=5e03e0&mms3=true\",\"mimetype\":\"application/pdf\",\"fileSha256\":\"aHhYmaLFUJLOMjOPv/fDXb4987EdWcBGTrend+yz3pc=\",\"fileLength\":\"57749\",\"mediaKey\":\"a2ETTrmljo8LtbuovYuRh+G7erYa21cXehwMahlaVyc=\",\"fileName\":\"test-documentation.pdf\",\"fileEncSha256\":\"Ay2Cfhfhgo5lbRROIfoznhTwdKX5l6kDv2aSriMk98E=\",\"directPath\":\"/v/t62.7119-24/40771768_2112715075856499_399986930701391294_n.enc?ccb=11-4&oh=01_Q5AaIPeh8RjG_yPf0IvODqhrdonYbcTpJDOsOgd7IW9rLqPu&oe=67E6FFE7&_nc_sid=5e03e0\",\"mediaKeyTimestamp\":\"1740608551\",\"caption\":\"test-documentation.pdf\"}},\"messageTimestamp\":\"1740608551\",\"status\":\"SERVER_ACK\"}}"

        response = double

        allow(response).to receive(:body) { content }
        allow(response).to receive(:code) { 200 }
        allow(RestClient).to receive(:post) { response }

        result = described_class.new(cellphone: cellphone, filepath: filepath).send_pdf

        expect(result).to be_nil
      end
    end

    context 'raises errors' do
      it 'when returns error in response body' do
        filepath = 'spec/fixtures/test-documentation.pdf'
        cellphone = '5511947271100'
        content = "{\"error\":true,\"message\":\"Falha de envio da mensagem\",\"messageData\":{\"key\":{\"remoteJid\":\"#{cellphone}@s.whatsapp.net\",\"fromMe\":true,\"id\":\"3EB001F1DCE595DBAB43E0\"},\"message\":{\"documentMessage\":{\"url\":\"https://mmg.whatsapp.net/v/t62.7119-24/40771768_2112715075856499_399986930701391294_n.enc?ccb=11-4&oh=01_Q5AaIPeh8RjG_yPf0IvODqhrdonYbcTpJDOsOgd7IW9rLqPu&oe=67E6FFE7&_nc_sid=5e03e0&mms3=true\",\"mimetype\":\"application/pdf\",\"fileSha256\":\"aHhYmaLFUJLOMjOPv/fDXb4987EdWcBGTrend+yz3pc=\",\"fileLength\":\"57749\",\"mediaKey\":\"a2ETTrmljo8LtbuovYuRh+G7erYa21cXehwMahlaVyc=\",\"fileName\":\"test-documentation.pdf\",\"fileEncSha256\":\"Ay2Cfhfhgo5lbRROIfoznhTwdKX5l6kDv2aSriMk98E=\",\"directPath\":\"/v/t62.7119-24/40771768_2112715075856499_399986930701391294_n.enc?ccb=11-4&oh=01_Q5AaIPeh8RjG_yPf0IvODqhrdonYbcTpJDOsOgd7IW9rLqPu&oe=67E6FFE7&_nc_sid=5e03e0\",\"mediaKeyTimestamp\":\"1740608551\",\"caption\":\"test-documentation.pdf\"}},\"messageTimestamp\":\"1740608551\",\"status\":\"SERVER_ACK\"}}"

        response = double

        allow(response).to receive(:body) { content }
        allow(response).to receive(:code) { 200 }
        allow(RestClient).to receive(:post) { response }

        expect do
          described_class.new(cellphone: cellphone, filepath: filepath).send_pdf
        end.to raise_error(StandardError, 'Falha de envio da mensagem')
      end

      it 'when no returns HTTP status code 200' do
        filepath = 'spec/fixtures/test-documentation.pdf'
        cellphone = '5511947271100'

        response = double

        allow(response).to receive(:body) { '{}' }
        allow(response).to receive(:code) { 500 }
        allow(RestClient).to receive(:post) { response }

        expect do
          described_class.new(cellphone: cellphone, filepath: filepath).send_pdf
        end.to raise_error(StandardError)
      end
    end
  end
end
