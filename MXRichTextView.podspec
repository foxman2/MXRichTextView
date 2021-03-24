#
# Be sure to run `pod lib lint MXRichTextView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MXRichTextView'
  s.version          = '1.0.0'
  s.summary          = 'A short description of MXRichTextView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/foxman2/MXRichTextView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'foxman2' => '395911263@qq.com' }
  s.source           = { :git => 'https://github.com/foxman2/MXRichTextView.git', :tag => s.version.to_s, :submodules => true}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.subspec 'SummerNote' do |summerNote|
    summerNote.resources = 'MXRichTextView/Assets/dist/*'
  end

  s.ios.deployment_target = '9.0'

  s.source_files = 'MXRichTextView/Classes/**/*'
  
   s.resource_bundles = {
     'MXRichTextView' => ['MXRichTextView/Assets/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'WebKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
