Pod::Spec.new do |s|
    s.name             = "mParticle-Singular"
    s.version          = "8.0.1"
    s.summary          = "Singular integration for mParticle"

    s.description      = "This is the Singular integration for mParticle"

    s.homepage         = "https://www.mparticle.com"
    s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
    s.author           = { "mParticle" => "support@mparticle.com" }
    s.source           = { :git => "https://github.com/mparticle-integrations/mparticle-apple-integration-Singular.git", :tag => s.version.to_s }
    s.social_media_url = "https://twitter.com/mparticle"

	s.static_framework = true
    s.ios.deployment_target = "8.0"
    s.ios.source_files      = 'mParticle-Singular/*.{h,m,mm}'
    s.ios.dependency 'mParticle-Apple-SDK/mParticle', '~> 7.0'
    s.ios.dependency 'Singular-SDK'
end
