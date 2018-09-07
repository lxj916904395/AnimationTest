//
//  ViewController2.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/7.
//

#import "ViewController2.h"
#import "MenuView.h"

@interface ViewController2 ()
@property(strong ,nonatomic) MenuView *menuView;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _menuView = [[MenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}
- (IBAction)back:(id)sender {
    CATransition *anim = [CATransition animation];
    //    anim.type = @"suckEffect";
    anim.type = @"pageUnCurl";
    //    anim.subtype = kCATransitionFromBottom;
    anim.duration = 1;
    [self.navigationController.view.layer  addAnimation:anim forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)menu:(id)sender {
    
    if (!_menuView.superview) {
        [_menuView showInView:self.view];
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
