//
//  ViewController.m
//  CLHaloLabel
//
//  Created by 李辉 on 15/12/16.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import "ViewController.h"
#import "CLHaloLabel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CLHaloLabel *haloLabel;

- (IBAction)startButtonClick:(UIButton *)sender;
- (IBAction)stopButtonClick:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.haloLabel.haloDuration = 5;
    self.haloLabel.haloWidth = 0.8;
    
    CLHaloLabel *lable = [[CLHaloLabel alloc] initWithFrame:CGRectMake(20, 200, 100, 30)];
    lable.text = @"从代码创建";
    lable.textColor = [UIColor greenColor];
    lable.haloColor = [UIColor redColor];
    [self.view addSubview:lable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonClick:(UIButton *)sender {
    self.haloLabel.animated = YES;
}

- (IBAction)stopButtonClick:(UIButton *)sender {
    self.haloLabel.animated = NO;
}
@end
