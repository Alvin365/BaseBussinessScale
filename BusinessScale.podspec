Pod::Spec.new do |s|
  s.name                  = "BusinessScale"
  s.version               = "1.0.0"
  s.summary               = "OKOK商用称的基础版本"
  s.homepage              = "https://192.168.0.90:8888/yangsen/CommerCialScale"
  s.license               = { :type => "MIT", :file => 'LICENSE.md' }
  s.author                = { "yangsen" => "yangsen@ichipsea.com" }
  s.platform              = :ios, "7.0"
  s.source                = { :git => "git@192.168.0.90:yangsen/CommerCialScale.git", :tag => s.version, :submodules => true}
 
  s.source_files          = "BusinessScale/**/*"
  s.public_header_files   = "BusinessScale/BusinessScale.h"
  s.frameworks = 'UIKit','Foundation','CoreTelephony','SystemConfiguration'
  s.libraries = "c++", "sqlite3.0","z.0","sqlite3.0"

  s.requires_arc          = true
  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'MBProgressHUD', '~> 0.9.1'
  s.dependency 'SDWebImage', '~>3.7'
  s.dependency 'FMDB'
  s.dependency 'ZXingObjC', '~> 3.0'
  s.dependency 'LKDBHelper'
  s.dependency 'Commercial-Bluetooth'

  s.subspec 'Common' do |c|
    c.source_files       = 'BusinessScale/Common/*.{h,m}'
    c.public_header_files= 'BusinessScale/Common/*.h'

    c.subspec 'Bussiness' do |cbs|
      cbs.source_files            = 'BusinessScale/Common/Bussiness/*.{h,m}'
    end

    c.subspec 'Category' do |ccs|
      ccs.source_files            = 'BusinessScale/Common/Category/*.{h,m}'
    end

    c.subspec 'Controller' do |ccts|
      ccts.source_files            = 'BusinessScale/Common/Controller/*.{h,m}'
    end

    c.subspec 'Lib' do |cls|
      cls.source_files            = 'BusinessScale/Common/Lib/{*,/*}'
      cls.public_header_files   = 'BusinessScale/Common/Lib/{*.h,/*.h}'
    end

    c.subspec 'Model' do |cms|
      cms.source_files            = 'BusinessScale/Common/Model/*.{h,m}'
      cms.public_header_files   = 'BusinessScale/Common/Model/*.h'
    end

    c.subspec 'Tool' do |cts|
      cts.source_files            = 'BusinessScale/Common/Tool/*.{h,m}'
      cts.public_header_files   = 'BusinessScale/Common/Tool/*.h'

      cts.subspec 'ALHttpTools' do |ctss|
        ctss.source_files            = 'BusinessScale/Common/Tool/ALHttpTools/*.{h,m}'
        ctss.public_header_files   = 'BusinessScale/Common/Tool/ALHttpTools/*.h'
      end
    end

    c.subspec 'View' do |cvs|
      cvs.source_files            = 'BusinessScale/Common/View/*.{h,m}'
      cvs.public_header_files   = 'BusinessScale/Common/View/*.h'
    end
  end

  s.subspec 'Weighing(称量)' do |cz|
    cz.source_files       = 'BusinessScale/Weighing(称量)/*.{h,m}'
    cz.public_header_files= 'BusinessScale/Weighing(称量)/*.h'

    cz.subspec 'Bussiness' do |czbs|
      czbs.source_files            = 'BusinessScale/Weighing(称量)/Bussiness/*.{h,m}'
    end

    cz.subspec 'Category' do |czcs|
      czcs.source_files            = 'BusinessScale/Weighing(称量)/Category/*.{h,m}'
    end

    cz.subspec 'Controller' do |czcts|
      czcts.source_files            = 'BusinessScale/Weighing(称量)/Controller/*.{h,m}'
    end

    cz.subspec 'ViewAndModel' do |czms|
      czms.source_files            = 'BusinessScale/Weighing(称量)/ViewAndModel/*.{h,m}'
      czms.public_header_files   = 'BusinessScale/Weighing(称量)/ViewAndModel/*.h'
    end

    cz.subspec 'Tool' do |czts|
      czts.source_files            = 'BusinessScale/Weighing(称量)/Tool/*.{h,m}'
      czts.public_header_files   = 'BusinessScale/Weighing(称量)/Tool/*.h'
    end
  end

  s.subspec 'Processing(流水)' do |cl|
    cl.source_files       = 'BusinessScale/Processing(流水)/*.{h,m}'
    cl.public_header_files= 'BusinessScale/Processing(流水)/*.h'

    cl.subspec 'Bussiness' do |clbs|
      clbs.source_files            = 'BusinessScale/Processing(流水)/Bussiness/*.{h,m}'
    end

    cl.subspec 'Category' do |clcs|
      clcs.source_files            = 'BusinessScale/Processing(流水)/Category/*.{h,m}'
    end

    cl.subspec 'Controller' do |clcts|
      clcts.source_files            = 'BusinessScale/Processing(流水)/Controller/*.{h,m}'
    end

    cl.subspec 'ViewAndModel' do |clms|
      clms.source_files            = 'BusinessScale/Processing(流水)/ViewAndModel/*.{h,m}'
      clms.public_header_files   = 'BusinessScale/Processing(流水)/ViewAndModel/*.h'
    end

    cl.subspec 'Tool' do |clts|
      clts.source_files            = 'BusinessScale/Processing(流水)/Tool/*.{h,m}'
      clts.public_header_files   = 'BusinessScale/Processing(流水)/Tool/*.h'
    end
  end

  s.subspec 'Chart(图表)' do |ct|
    ct.source_files       = 'BusinessScale/Chart(图表)/*.{h,m}'
    ct.public_header_files= 'BusinessScale/Chart(图表)/*.h'

    ct.subspec 'Bussiness' do |ctbs|
      ctbs.source_files            = 'BusinessScale/Chart(图表)/Bussiness/*.{h,m}'
    end

    ct.subspec 'Category' do |ctcs|
      ctcs.source_files            = 'BusinessScale/Chart(图表)/Category/*.{h,m}'
    end

    ct.subspec 'Controller' do |ctcts|
      ctcts.source_files            = 'BusinessScale/Chart(图表)/Controller/*.{h,m}'
    end


    ct.subspec 'ViewAndModel' do |ctms|
      ctms.source_files            = 'BusinessScale/Chart(图表)/ViewAndModel/*.{h,m}'
      ctms.public_header_files   = 'BusinessScale/Chart(图表)/ViewAndModel/*.h'
    end

    ct.subspec 'Tool' do |ctts|
      ctts.source_files            = 'BusinessScale/Chart(图表)/Tool/*.{h,m}'
      ctts.public_header_files   = 'BusinessScale/Chart(图表)/Tool/*.h'
    end
  end

  s.subspec 'Setting' do |cs|
    cs.source_files       = 'BusinessScale/Setting/*.{h,m}'
    cs.public_header_files= 'BusinessScale/Setting/*.h'

    cs.subspec 'Bussiness' do |csbs|
      csbs.source_files            = 'BusinessScale/Setting/Bussiness/*.{h,m}'
    end

    cs.subspec 'Category' do |cscs|
      cscs.source_files            = 'BusinessScale/Setting/Category/*.{h,m}'
    end

    cs.subspec 'Controller' do |cscts|
      cscts.source_files            = 'BusinessScale/Setting/Controller/*.{h,m}'
    end

    cs.subspec 'ViewAndModel' do |csms|
      csms.source_files            = 'BusinessScale/Setting/ViewAndModel/*.{h,m}'
      csms.public_header_files   = 'BusinessScale/Setting/ViewAndModel/*.h'
    end

    cs.subspec 'Tool' do |csts|
      csts.source_files            = 'BusinessScale/Setting/Tool/*.{h,m}'
      csts.public_header_files   = 'BusinessScale/Setting/Tool/*.h'
    end
  end

  s.subspec 'Login' do |cls|
    cls.source_files       = 'BusinessScale/Login/*.{h,m}'
    cls.public_header_files= 'BusinessScale/Login/*.h'

    cls.subspec 'Bussiness' do |cslbs|
      cslbs.source_files            = 'BusinessScale/Login/Bussiness/*.{h,m}'
    end

    cls.subspec 'Category' do |cslcs|
      cslcs.source_files            = 'BusinessScale/Login/Category/*.{h,m}'
    end

    cls.subspec 'Controller' do |cslcts|
      cslcts.source_files            = 'BusinessScale/Login/Controller/*.{h,m}'
    end

    cls.subspec 'ViewAndModel' do |cslms|
      cslms.source_files            = 'BusinessScale/Login/ViewAndModel/*.{h,m}'
      cslms.public_header_files   = 'BusinessScale/Login/ViewAndModel/*.h'
    end

    cls.subspec 'Tool' do |cslts|
      cslts.source_files            = 'BusinessScale/Login/Tool/*.{h,m}'
      cslts.public_header_files   = 'BusinessScale/Login/Tool/*.h'
    end
  end

  s.subspec 'Bluetooth' do |cbs|
    cbs.source_files       = 'BusinessScale/Bluetooth/*.{h,m}'
    cbs.public_header_files= 'BusinessScale/Bluetooth/*.h'

    cbs.subspec 'Bussiness' do |cslbs|
      cslbs.source_files            = 'BusinessScale/Bluetooth/Bussiness/*.{h,m}'
    end

    cbs.subspec 'Category' do |cslcs|
      cslcs.source_files            = 'BusinessScale/Bluetooth/Category/*.{h,m}'
    end

    cbs.subspec 'Controller' do |cslcts|
      cslcts.source_files            = 'BusinessScale/Bluetooth/Controller/*.{h,m}'
    end

    cbs.subspec 'ViewAndModel' do |cslms|
      cslms.source_files            = 'BusinessScale/Bluetooth/ViewAndModel/*.{h,m}'
      cslms.public_header_files   = 'BusinessScale/Bluetooth/ViewAndModel/*.h'
    end

    cbs.subspec 'Tool' do |cslts|
      cslts.source_files            = 'BusinessScale/Bluetooth/Tool/*.{h,m}'
      cslts.public_header_files   = 'BusinessScale/Bluetooth/Tool/*.h'
    end
  end

  s.subspec 'FileSource' do |csfs|
    csfs.source_files       = 'BusinessScale/FileSource/**/*'
    csfs.public_header_files= 'BusinessScale/Bluetooth/*.h'
  end

end