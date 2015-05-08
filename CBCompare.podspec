#
# Be sure to run `pod lib lint CBCompareViewController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name = 'CBCompare'
s.version = '0.1.0'
s.license = 'MIT'
s.summary = 'A swift view controller to compare two views of content.'
s.homepage = 'https://github.com/caseybbrumbaugh/CBCompareViewController'
s.authors = { "Casey Brumbaugh" => "caseybbrumbaugh@gmail.com" }
s.source = { :git => "https://github.com/caseybbrumbaugh/CBCompareViewController.git", :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'Pod/Classes/*.swift'

s.requires_arc = true
end
