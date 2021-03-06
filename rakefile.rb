=begin
Rakefile used to generate BayXP website as well as uploading it. You will 
need install 'BuildMaster' gem by typing 'gem install BuildMaster' and 'redcloth' gem
by typing 'gem install RedCloth' and 'echoe' gem by typing 'gem install echoe'

The default target will rebuild the website and upload the content

The 'build' target will generate the website to output directory. The 'server' target will launch the server locally at port 2000. In this way, 
you can use the browser to see the result of your change on the source content immediately through refresh.

In order to make ftp work, you will need to create a file 'account.rb' 
under the current directory that contains something like the following:

USERNAME='username'
PASSWORD='password'

=end
$:.unshift File.dirname(__FILE__)

require 'buildmaster/site'
require 'buildmaster/cotta'
require 'buildmaster/project/ftp_driver'
require 'rake'

dir = BuildMaster::Cotta.file(__FILE__).parent
SITE_SPEC = BuildMaster::SiteSpec.new(__FILE__) do |spec|
  spec.template_file = dir.file('content/template.html').path
  spec.content_dir = dir.dir('content').path
  spec.output_dir = dir.dir('output').path
end

task :default => [:clean, :build, :ftp]

task :clean do
  SITE_SPEC.output_dir.delete
end

task :build do
  BuildMaster::Site.new(SITE_SPEC).build
end

task :server do
  BuildMaster::Site.new(SITE_SPEC).server
end

task :ftp do
  require 'account' #This file is not checked in.
  puts "ftp to bayxp.org using #{USERNAME}"
  ftp = BuildMaster::FtpDriver.new('bayxp.org', USERNAME, PASSWORD)
  ftp.upload(SITE_SPEC.output_dir)
end
