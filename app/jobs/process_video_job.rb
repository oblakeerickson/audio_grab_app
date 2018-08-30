require 'fileutils'

class ProcessVideoJob < ApplicationJob
  queue_as :default

  def perform(*args)
    system "youtube-dl -o 'tmp/%(title)s.%(ext)s' --restrict-filenames --extract-audio --audio-format mp3 #{args[0]}"
    file = Dir["tmp/*.mp3"][0]

    a = Mechanize.new
    login_page = a.get('https://overcast.fm/login')
    my_page = login_page.form do |form|
      form.email = AudioGrabApp::Application.credentials.overcast[:username]
      form.password = AudioGrabApp::Application.credentials.overcast[:password]
    end.submit
    upload_page = a.click(my_page.link_with(:text => /ploads/))
    upload_page.form_with(:method => 'POST') do |upload_form|
      upload_form.file_uploads.first.file_name = file
    end.submit
    File.delete file
  end
end
