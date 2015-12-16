# CLHaloLabel 1.0
拥有光晕扫过效果的Label 

<br />
作者：李辉 <br />
联系方式：6545823@qq.com <br />
编译环境：Xcode 7.2 <br />
运行环境：iOS 9.2 运行正常 <br />
您在使用该控件的过程中，如有任何疑问或建议，请通过邮箱联系我，谢谢！ <br />

<br />
![image](https://github.com/changelee82/CLHaloLabel/raw/master/Demo.gif)
<br />

使用方法
===============
可使用自动布局或代码添加该控件； <br />
此Label不能设置背景色，否则无法显示动画效果； <br />

    #import "CLHaloLabel.h"
    
    self.haloLabel.haloDuration = 5;
    self.haloLabel.haloWidth = 0.8;
    
    CLHaloLabel *lable = [[CLHaloLabel alloc] initWithFrame:CGRectMake(20, 200, 100, 30)];
    lable.text = @"从代码创建";
    lable.textColor = [UIColor greenColor];
    lable.haloColor = [UIColor redColor];
    [self.view addSubview:lable];

详细的示例请参考代码。 <br />

历史版本
===============
v1.0 - 2015-12-16 <br />
Added <br />
基础功能完成 <br />
