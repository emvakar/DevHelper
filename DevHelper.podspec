Pod::Spec.new do |s|
    
    # 1
    s.platform = :ios
    s.ios.deployment_target = '10.0'
    s.name = "DevHelper"
    s.summary = "DevHelper swift 4.2 framework for simple development amazing apps."
    s.requires_arc = true
    
    # 2
    s.version = "1.0.0"
    
    # 3
    s.license = { :type => "MIT", :file => "LICENSE" }
    
    # 4 - Replace with your name and e-mail address
    s.author = { "Emil Karimov" => "emvakar@gmail.com" }
    
    # 5 - Replace this URL with your own Github page's URL (from the address bar)
    s.homepage = "https://github.com/emvakar/DevHelper.git"
    
    # 6 - Replace this URL with your own Git URL from "Quick Setup"
    s.source = { :git => "https://github.com/emvakar/DevHelper.git", :tag => "#{s.version}"}
    
    # 7
    s.framework = "UIKit"
    s.dependency 'SnapKit', '4.2.0'
    s.dependency 'KRProgressHUD', '3.4.0'
    
    # 8
    s.source_files = "DevHelper/**/*.{swift}"
    
    # 9
    s.resources = "DevHelper/**/*.{png,jpeg,jpg,storyboard,xib}"
    s.resource_bundles = {
        'DevHelperAssets' => ['DevHelper/**/*.xcassets']
    }
end
