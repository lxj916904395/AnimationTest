//
//  Customtrans1ViewController.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/11.
//

#import "Customtrans1ViewController.h"

#import "Customtrans2ViewController.h"
#import "CustomTranst.h"

//实现navigation 协议  UINavigationControllerDelegate
@interface Customtrans1ViewController ()<UINavigationControllerDelegate>

@end

@implementation Customtrans1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation
    fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        //如果是push，采用自定义转场动画
        
        CustomTranst *custom = [CustomTranst new];
        custom.isPush = YES;
        return custom;
    }else{
        return nil;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.clickPoint =  [[touches anyObject] locationInView:self.view];
    [self.navigationController pushViewController:[Customtrans2ViewController new] animated:YES];
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
