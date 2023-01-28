RSpec.configure do |config|
  # デフォルトでは高速なRack::Testドライバを使う
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # より複雑なブラウザ操作が必要な場合はJavaScriptが実行可能なドライバを設定する
  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome, using: :chrome, options: {
      browser: :remote,
      url: ENV.fetch("SELENIUM_DRIVER_URL"),
    }

    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 4444
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end

Capybara.register_driver :selenium_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    'goog:chromeOptions' => {
      args: [
        '--headless',
        '--window-size=1400,1400',
        '--no-sandbox',
        '--disable-dev-shm-usage',
        '--lang=ja-JP',
        'proxy-bypass-list=<-loopback>',
      ],
    }
  )
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: 'http://selenium_chrome:4444/wd/hub',
    capabilities: capabilities,
  )
end