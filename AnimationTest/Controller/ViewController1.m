//
//  ViewController1.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/6.
//

#import "ViewController1.h"
#import "ViewController2.h"

/**
 复杂动画一般由多种动画组成，所以需要对其进行拆分
 
 例如点赞效果
 1.点击按钮图片改变，并放大或缩小
 2.选中状态存在粒子发射
 */

@interface ViewController1 (){
   
}

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property(strong ,nonatomic) CAEmitterLayer *emitterLayer;//粒子发射层

@end

@implementation ViewController1
#pragma mark ***************** 页面名称
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self explosion];
//    [self _initEmitterLayer];
}

//添加爆炸效果
- (void)explosion{
    _emitterLayer = [CAEmitterLayer layer];
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.name = @"explosionCell";
    cell.lifetime = .7;
    cell.birthRate = 4000;
    cell.velocity = 50;//中间值
    cell.velocityRange = 15;//(50+-15)
    cell.scale = .03;
    cell.scaleRange = .02;
    cell.contents = (id)[UIImage imageNamed:@"sparkle"].CGImage;
    
    //设置粒子系统大小，位置，方向
    _emitterLayer.name = @"explosionLayer";
    _emitterLayer.emitterShape = kCAEmitterLayerCircle;
    _emitterLayer.emitterMode = kCAEmitterLayerOutline;
    _emitterLayer.emitterSize = CGSizeMake(25, 25);
    _emitterLayer.emitterCells = @[cell];
    _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    _emitterLayer.masksToBounds = NO;
    _emitterLayer.birthRate = 0;
    _emitterLayer.position = CGPointMake(CGRectGetWidth(_likeBtn.bounds)/2, CGRectGetHeight(_likeBtn.bounds)/2);
    
    [_likeBtn.layer addSublayer:_emitterLayer];
    
    
}
#pragma mark ***************** CAEmitterLayer
- (void)_initEmitterLayer{
    _emitterLayer = [CAEmitterLayer layer];
    
    //发射的粒子
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    //内容标识
    cell.name = @"firework";
    //粒子的内容
    cell.contents = (id)[UIImage imageNamed:@"sparkle"].CGImage;
    //出生率，ji
    cell.birthRate = 4000;
    
    //粒子存在时间
    cell.lifetime = 0.7;
    //粒子存在时间波动范围，
    // >0,粒子存活的总时间 = cell.lifetime + cell.lifetimeRange
    // <0,粒子存活的总时间 = cell.lifetime - cell.lifetimeRange
//    cell.lifetimeRange = .3;

    //发射速度
    cell.velocity = 50;
    cell.velocityRange = 15;
    
//    cell.alphaSpeed = -0.4;
    cell.scale = .03;
    cell.scaleRange = .02;
    
//    cell.emissionRange = M_PI * 2.0;
    
    
    _emitterLayer.masksToBounds = NO;

    //总的出生率 = cell.birthRate*_emitterLayer.birthRate
    _emitterLayer.birthRate = 0;
    
    //设置发射器的发射内容，可为多个
    _emitterLayer.emitterCells = @[cell];
    
    //渲染模式
    _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    
    //发射模式
    _emitterLayer.emitterMode = kCAEmitterLayerOutline;

    //发射源形状
    _emitterLayer.emitterShape = kCAEmitterLayerCircle;
    
    _emitterLayer.position  = CGPointMake(CGRectGetWidth(self.likeBtn.bounds)/2, CGRectGetHeight(self.likeBtn.bounds)/2);
    
    //发射源大小
    _emitterLayer.emitterSize = CGSizeMake(25, 25);

    
    [self.likeBtn.layer addSublayer:_emitterLayer];
}

#pragma mark ***************** Action

- (IBAction)clickLike:(id)sender {
    self.likeBtn.selected = !self.likeBtn.selected;
    
    [self scaleAnim];
    
    if (self.likeBtn.selected) {
        _emitterLayer.birthRate = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.emitterLayer.birthRate = 0;
        });
    }
}

//按钮缩放动画
- (void)scaleAnim{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.scale";
    if (self.likeBtn.selected) {
        anim.duration = .5f;
        anim.values = @[@1.2,@1.5,@0.8,@1];
    }else{
        anim.duration = .3f;
        anim.values = @[@0.8,@0.5,@1];
    }
    
    [self.likeBtn.layer addAnimation:anim forKey:nil];
}


- (IBAction)jump:(id)sender {
    CATransition *anim = [CATransition animation];
    anim.type = @"oglFlip";
    anim.subtype = kCATransitionFromBottom;
    anim.duration = 1;
    [self.navigationController.view.layer  addAnimation:anim forKey:nil];
    
    [self.navigationController pushViewController:[ViewController2 new] animated:NO];
}

- (IBAction)back:(id)sender {
    CATransition *anim = [CATransition animation];
        anim.type = @"suckEffect";
    //    anim.subtype = kCATransitionFromBottom;
    anim.duration = 1;
    [self.navigationController.view.layer  addAnimation:anim forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
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
