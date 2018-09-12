//
//  DynamicViewController.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/12.
//

#import "DynamicViewController.h"

@interface DynamicViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//物理引擎驱动
@property(strong ,nonatomic) UIDynamicAnimator *animator;

//吸附行为
@property(strong ,nonatomic) UIAttachmentBehavior *attach;

@end

@implementation DynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //初始化引擎，设置容器view
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //创建自用落体行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[_imageView]];
    //添加行为
    [_animator addBehavior:gravity];
    
    //碰撞行为
    UICollisionBehavior *collosion = [[UICollisionBehavior alloc] initWithItems:@[_imageView]];
    //在边界处发生碰撞
    collosion.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:collosion];
    
    //设置行为属性
    UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:@[_imageView]];
    //碰撞时的弹性系数（0~1）
    item.elasticity = .5f;
    [_animator addBehavior:item];

    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_imageView addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)ges{
    if (ges.state == UIGestureRecognizerStateBegan) {
        //初始化吸附行为
        //偏移量
        UIOffset offset = UIOffsetMake(-30, -30);
//        _attach = [[UIAttachmentBehavior alloc] initWithItem:_imageView attachedToAnchor:[ges locationInView:self.view]];
        _attach = [[UIAttachmentBehavior alloc] initWithItem:_imageView offsetFromCenter:offset attachedToAnchor:[ges locationInView:self.view]];
        [_animator addBehavior:_attach];
    }
    else if (ges.state == UIGestureRecognizerStateChanged) {
        //更新锚点
        [_attach setAnchorPoint:[ges locationInView:self.view]];
    }  else if (ges.state == UIGestureRecognizerStateEnded) {
        [_animator removeBehavior:_attach];
    }
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
