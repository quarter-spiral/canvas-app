require 'tmpdir'

mainjs = File.read(Capybara::Poltergeist::Client::PHANTOMJS_SCRIPT)

def patch_js_file(file, pattern, &blck)
  js = File.read(file)
  js.gsub!(pattern, &blck)

  patch_path = "#{Dir.tmpdir}/poltergeist_patch_#{File.basename(file)}"
  File.open(patch_path, 'w') do |file|
    file.write js
  end
  patch_path
end

#patch webpage.js
webpage_js_path = File.expand_path('../web_page.js', Capybara::Poltergeist::Client::PHANTOMJS_SCRIPT)
patched_webpage_js_path = patch_js_file(webpage_js_path, 'return WebPage;') do
  <<-EOS
    WebPage.prototype.pages = function() {
      return this["native"].pagesWindowName;
    };
    console.log('new webpage!');
    return WebPage;
  EOS
end

absolute_agent_js_path = File.expand_path('../agent.js', Capybara::Poltergeist::Client::PHANTOMJS_SCRIPT)
patched_webpage_js_path = patch_js_file(patched_webpage_js_path, /^.*"\/agent.js"\);$/) do
  "return this[\"native\"].injectJs(\"#{absolute_agent_js_path}\");"
end

#patch browser.js
browser_js_path = File.expand_path('../browser.js', Capybara::Poltergeist::Client::PHANTOMJS_SCRIPT)
patched_browser_js_path = patch_js_file(browser_js_path, 'return Browser;') do
  <<-EOS
    Browser.prototype.pages = function() {
      return this.sendResponse(this.page.pages());
    };
    console.log('new browser!');
    return Browser;
  EOS
end

patched_main_js_path = patch_js_file(Capybara::Poltergeist::Client::PHANTOMJS_SCRIPT, /^.*"\/web_page.js"\);$/) do
  "console.log(phantom.injectJs(\"#{patched_webpage_js_path}\"));"
end

absolute_node_js_path = File.expand_path('../node.js', Capybara::Poltergeist::Client::PHANTOMJS_SCRIPT)
patched_main_js_path = patch_js_file(patched_main_js_path, /^.*"\/node.js"\);$/) do
  "console.log(phantom.injectJs(\"#{absolute_node_js_path}\"));"
end

absolute_connection_js_path = File.expand_path('../connection.js', Capybara::Poltergeist::Client::PHANTOMJS_SCRIPT)
patched_main_js_path = patch_js_file(patched_main_js_path, /^.*"\/connection.js"\);$/) do
  "console.log(phantom.injectJs(\"#{absolute_connection_js_path}\"));"
end

patched_main_js_path = patch_js_file(patched_main_js_path, /^.*"\/browser.js"\);$/) do
  "console.log(phantom.injectJs(\"#{patched_browser_js_path}\"));"
end

Capybara::Poltergeist::Client::PHANTOMJS_SCRIPT.gsub!(/^.*$/, patched_main_js_path)

class Capybara::Poltergeist::Browser
  def window_handles
    command 'pages'
  end
end
