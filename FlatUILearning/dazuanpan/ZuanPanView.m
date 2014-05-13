//
//  ZuanPanView.m
//  FlatUILearning
//
//  Created by gang zeng on 14-5-2.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import "ZuanPanView.h"
#import "Dazuanpan.h"
#import "CircleLayout.h"
#import "lightCell.h"

@interface ZuanPanView()
{
    int state;
}
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,weak) IBOutlet  UIImageView *zuanPanBottomView;
@property (nonatomic,weak) IBOutlet UIView *zunPanMiddleView;
@property (nonatomic,weak) IBOutlet UIImageView *zuanPanPointerView;


@end

@implementation ZuanPanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setUpZuanPanViewWithTypeList:(NSMutableArray *) typeList
{
    int k=1;
    for (int i=11; i<23; i++) {
        UIImageView *imageView =(UIImageView *)[_zunPanMiddleView viewWithTag:i ];
        imageView.transform = CGAffineTransformMakeRotation(k*2*M_PI/24);
        k=k+2;
    }
    for (Dazuanpan *type in typeList) {
        UIImageView *imageView =(UIImageView *)[_zunPanMiddleView viewWithTag:type.number];
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"result_%d",type.awardTimes]];
        imageView.hidden=NO;
    }
    
    _circleLightView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 350,350) collectionViewLayout:[[CircleLayout alloc] init]];
    _circleLightView.center=CGPointMake(179, 180);
    _circleLightView.delegate=self;
    _circleLightView.dataSource=self;
    _circleLightView.backgroundColor=[UIColor clearColor];
    [_circleLightView registerClass:[lightCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    [self addSubview:_circleLightView];
    [_circleLightView reloadData];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(startLightsAnimation:) userInfo:@1 repeats:YES];
}

-(void) startLightsAnimation:(NSTimer *)timer
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_circleLightView reloadData];
        });
    });
    
    
}
-(void) stopLightingAnimation
{
    [_timer invalidate];
    _timer = nil;
}

-(void) startRollingToNumber:(int) number
{
    [_delegate zuanPanWillStartRolling];
    int k=(number-10)*2-1;
    int direction = 1;
    CGPoint oldAnchorPoint=_zunPanMiddleView.layer.anchorPoint;
    _zunPanMiddleView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [_zunPanMiddleView.layer setPosition:CGPointMake(_zunPanMiddleView.layer.position.x + _zunPanMiddleView.layer.bounds.size.width * (_zunPanMiddleView.layer.anchorPoint.x - oldAnchorPoint.x), _zunPanMiddleView.layer.position.y + _zunPanMiddleView.layer.bounds.size.height * (_zunPanMiddleView.layer.anchorPoint.y - oldAnchorPoint.y))];
    
	CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.timingFunction = [CAMediaTimingFunction
                                        functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
	rotationAnimation.toValue = @((20*(M_PI)+ ((24-k)*2*M_PI/24))* direction);
	rotationAnimation.duration = 7.0f;
    rotationAnimation.autoreverses=NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.delegate=self;
	[_zunPanMiddleView.layer addAnimation:rotationAnimation forKey:@"scanAnimation"];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_delegate zuanPanDidEndRolling];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    lightCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    
    [cell setLightImageWithType:indexPath.row%2];
    
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
