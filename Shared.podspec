Pod::Spec.new do |s|
    s.name             = 'Shared'
    s.version          = '0.1.0'
    s.summary          = 'TODO'

    s.homepage         = 'https://github.com/whimzyapp/shared-swift'
    #s.license          = { :type => 'Proprietary', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/whimzyapp/shared-swift.git', :tag => s.version.to_s }

    s.source_files = 'Sources/Shared/**/*'

    s.swift_version = '5.0'

    s.ios.deployment_target = '12.0'

    s.module_name = 'Shared'

    s.dependency 'WolfCore'
    s.dependency 'WolfDateTime'
end
