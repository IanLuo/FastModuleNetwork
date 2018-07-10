Pod::Spec.new do |s|
  s.name         = "FastModuleNetwork"
  s.version      = "0.0.1"
  s.summary      = "FastModuleNetwork"
  s.description  = "Provide network access for FastModule project"
  s.homepage     = "https://github.com/IanLuo/FastModuleNetwork"
  s.license      = "MIT"
  s.author             = { "luoxu" => "ianluo63@gmail.com" }
  s.source       = { :git => "git@github.com:IanLuo/FastModuleNetwork.git", :tag => "#{s.version}" }
  s.source_files  ="Sources/**/*.swift"
  s.dependency "Alamofire"
  s.denpendency "FastModule"

end
