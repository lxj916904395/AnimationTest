//
//  Customtrans2ViewController.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/11.
//

#import "Customtrans2ViewController.h"
#import "CustomTranst.h"

@interface Customtrans2ViewController ()<UINavigationControllerDelegate>

@end

@implementation Customtrans2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.actionBtn.layer.masksToBounds = YES;
    self.actionBtn.layer.cornerRadius = 40;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPop) {
        //采用自定义转场动画
        CustomTranst *custom = [CustomTranst new];
        custom.isPush = NO;
        return custom;
    }else{
        return nil;
    }
}

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
