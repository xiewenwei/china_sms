# encoding: utf-8
require 'spec_helper'

describe "Yunpian" do
  describe "#to" do
    let(:apikey) { '2022b1529967a8cb788c05ddd9fc339e' }
    let(:url) { "http://yunpian.com/v1/sms/tpl_send.json" }
    let(:content) { '云片测试：验证码 1234。' }
    subject { ChinaSMS::Service::Yunpian.to phone, content, password: apikey }

    describe 'single phone' do
      let(:phone) { '13928452841' }

      before do
        stub_request(:post, url).
          with(body: {apikey: apikey, mobile: phone, tpl_id: 2, tpl_value: "#code#=云片测试：验证码 1234。&#company#=云片网" },
               headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'yunpian.com', 'User-Agent'=>'Ruby'}).
          to_return(body: {"code" => 0, "msg" => "OK", "result" => {"count" => 1, "fee" => 1, "sid" => 592762800}}.to_json )
      end

      its([:code]) { should eql 0 }
      its([:msg]) { should eql "OK" }
    end

    context 'invalid key' do
      let(:phone) { '13928452841' }
      let(:apikey) { '666666' }

      before do
        stub_request(:post, url).
          with(body: {}).
          to_return(body: {"code" => -1, "msg" => "非法的apikey", "detail" => "请检查的apikey是否正确"}.to_json )
      end

      its([:code]) { should eql -1 }
      its([:msg]) { should eql "非法的apikey" }
      its([:detail]) { should eql "请检查的apikey是否正确" }
    end

  end
end
