Pod::Spec.new do |s|
    s.name             = "mParticle-Singular"
    s.version          = "6.11.0"
    s.summary          = "Singular integration for mParticle"

    s.description      = <<-DESC
                       This is the Singular integration for mParticle.
                       DESC

    s.homepage         = "https://www.mparticle.com"
    s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
    s.author           = { "mParticle" => "support@mparticle.com" }
    s.source           = { :git => "https://github.com/mparticle-integrations/mparticle-apple-integration-Singular.git", :tag => s.version.to_s }
    s.social_media_url = "https://twitter.com/mparticles"

    s.ios.deployment_target = "8.0"
    s.ios.source_files      = 'mParticle-Singular/*.{h,m,mm}'
    s.ios.dependency 'mParticle-Apple-SDK/mParticle', '~> 6.11.0'
    #s.ios.dependency 'Singular', '9.9.9'
end
