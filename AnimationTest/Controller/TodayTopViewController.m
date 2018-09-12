//
//  TodayTopViewController.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/12.
//

#import "TodayTopViewController.h"

@interface TodayTopViewController ()

@end

@implementation TodayTopViewController
#pragma mark ***************** 页面名称
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initUI];
}

#pragma mark ***************** lift cycle


#pragma mark ***************** ui
- (void)_initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ***************** lazy load 



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
