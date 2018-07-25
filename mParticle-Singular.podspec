Pod::Spec.new do |s|
    s.name             = "mParticle-Singular"
    s.version          = "7.5.1"
    s.summary          = "Singular integration for mParticle"

    s.description      = "This is the Singular integration for mParticle"

    s.homepage         = "https://www.mparticle.com"
    s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
    s.author           = { "mParticle" => "support@mparticle.com" }
    s.source           = { :git => "https://github.com/mparticle-integrations/mparticle-apple-integration-Singular.git", :tag => s.version.to_s }
    s.social_media_url = "https://twitter.com/mparticles"

    s.ios.deployment_target = "8.0"
    s.ios.source_files      = 'mParticle-Singular/*.{h,m,mm}', 'SingularSDK/Singular.h'
    s.ios.dependency 'mParticle-Apple-SDK/mParticle', '~> 7.5.0'
    s.ios.vendored_library = 'SingularSDK/libSingular.a'
    s.ios.libraries = ['sqlite3', 'z']
    s.ios.frameworks = 'SystemConfiguration'
    s.ios.pod_target_xcconfig = {
        'LIBRARY_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/mParticle-Singular/SingularSDK/**',
        'OTHER_LDFLAGS' => '$(inherited) -l"Singular"'
    }
end
