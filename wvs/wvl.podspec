#
# Be sure to run `pod lib lint wvl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'wvl'
  s.version          = '0.1.0'
  s.summary          = 'A short description of wvl.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/admin/wvl'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'admin' => 'admin' }
  s.source           = { :git => 'https://github.com/admin/wvl.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'wvs/Classes/**/*'
  s.prefix_header_file = 'wvs/Classes/wvs/prefix.pch'
  s.public_header_files = 'wvs/Classes/wvs/WVS.h'
  s.requires_arc = false
  s.xcconfig = {
    'OTHER_CFLAGS' => '-fembed-bitcode',
#    'OTHER_CFLAGS' => '-fembed-bitcode -kce-fla=4 -kce-fla-chance=70 -kce-bcf=4 -kce-bcf-prob=70 -kce-bcf-chance=70 -kce-str=1 ',
    'ONLY_ACTIVE_ARCH' => 'NO',
    'OTHER_LDFLAGS' => '$(inherited)',
    'HEADER_SEARCH_PATHS' => '$(inherited)',
    'LIBRARY_SEARCH_PATHS' => '$(inherited)'
  }
  
  wvl_script = <<-EOF
  FMK_NAME=${PROJECT_NAME}
  if [ "${ACTION}" = "build" ]
    then
    INSTALL_DIR=${SRCROOT}/Products/wvl
    DEVICE_DIR=${BUILD_ROOT}/${CONFIGURATION}-iphoneos/wvl
    SIMULATOR_DIR=${BUILD_ROOT}/${CONFIGURATION}-iphonesimulator/wvl
    
    # -configuration ${CONFIGURATION}
    # Clean and Building both architectures.
    #xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos clean build
    #xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator clean build
    
    if [ -d "${INSTALL_DIR}" ]
      then
      rm -rf "${INSTALL_DIR}"
    fi
    mkdir -p "${INSTALL_DIR}"
    cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"
    #ditto "${DEVICE_DIR}/Headers" "${INSTALL_DIR}/Headers"
    lipo -create "${DEVICE_DIR}/libwvl.a" "${SIMULATOR_DIR}/libwvl.a" -output "${INSTALL_DIR}/libwvl.a"
    #这个是合并完成后打开对应的文件夹，你就可以直接看到文件了
    #open "${SRCROOT}/Products/wvl"
  fi
  EOF
  s.script_phase = { :name => 'rebuild_a', :script => wvl_script, :execution_position => :after_compile }
  s.static_framework = true
end
