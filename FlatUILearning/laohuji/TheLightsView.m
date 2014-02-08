//
//  TheLightsView.m
//  FlatUILearning
//
//  Created by gang zeng on 14-1-2.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import "TheLightsView.h"

@interface TheLightsView ()
{
    float lastX;
    float lastY;
}

@property (nonatomic,assign) int row;
@property (nonatomic,assign) int column;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableArray *theLightsArray;
@end

@implementation TheLightsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withRow:(int) row withColumn:(int) column
{
    self = [super initWithFrame:frame];
    if (self) {
        _row=row;
        _column=column;
        _theLightsArray =[NSMutableArray array];
        [self setupTheLightView];
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(9, 9.0f, lastX-9, lastY-10.0f)];
        bgView.backgroundColor=[UIColor blackColor];
        [self insertSubview:bgView atIndex:0];
    }
    return self;
}


-(void) setupTheLightView
{
    int tag=1;
    float centerY=0;

    for (int i=0; i< _row;i++) {
        if (i==0 || i== _row-1) {
            float centerX=0;
            for (int j=0; j<_column; j++) {
                
                float width=26;
                NSNumber *type=@1;
                NSNumber *colorType=@1;
                float gap=9;
                if (j%5!=0) {
                    width=16.5;
                    type=@0;
                    gap=5;
                    if (j%2==0) {
                        colorType=@0;
                    }
                }
                NSMutableDictionary *tempObject=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:tag],@"tag",type,@"type",colorType,@"colorType", nil];
                UIImageView *tempImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
                tempImageView.center=CGPointMake(centerX+gap, centerY+9.0f);
                tempImageView.image=[self getImageWithType:type.intValue andImageType:colorType.intValue];
                tempImageView.tag=tag;
                if (j==_column-1) {
                    lastX=centerX+gap;
                }
                centerX+=gap*2;
                [self addSubview:tempImageView];
                [_theLightsArray addObject:tempObject];
                tag++;
            }
            if (i== _row-1) {
                lastY=centerY+11.5f;
            }
            centerY+=20;
        }else{
            float width=26;
            NSNumber *type=@1;
            NSNumber *colorType=@1;
            float gap=9;
            if (i%3!=0) {
                width=16.5;
                type=@0;
                gap=5;
                if (i%2==0) {
                    colorType=@0;
                }
            }
            NSMutableDictionary *tempObject=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:tag],@"tag",type,@"type",colorType,@"colorType", nil];
            UIImageView *tempImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
            tempImageView.center=CGPointMake(10, centerY+gap);
            tempImageView.image=[self getImageWithType:type.intValue andImageType:colorType.intValue];
            tempImageView.tag=tag;
            [self addSubview:tempImageView];
            [_theLightsArray addObject:tempObject];
            tag++;
            tempObject=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:tag],@"tag",type,@"type",colorType,@"colorType", nil];
            tempImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
            tempImageView.center=CGPointMake(lastX, centerY+gap);
            tempImageView.image=[self getImageWithType:type.intValue andImageType:colorType.intValue];
            tempImageView.tag=tag;
            [self addSubview:tempImageView];
            [_theLightsArray addObject:tempObject];
            tag++;
            centerY+=gap*2;
        }
        
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(startLightsAnimation:) userInfo:@1 repeats:YES];
}

-(void) startLightsAnimation:(NSTimer *)timer
{
    int mode =[timer.userInfo integerValue];
    if (mode==1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self changeLightNormalMode];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showTheLights];
            });
        });
    }
    


}


-(void) changeLightNormalMode
{
    for (int i=0; i<_theLightsArray.count; i++) {
        NSMutableDictionary *theObject = _theLightsArray[i];
        int type=[[theObject objectForKey:@"type"] intValue];
        if (type==1) {
            NSUInteger imageType = abs(arc4random() % 5)+1;
            [theObject setObject:[NSNumber numberWithInt:imageType] forKey:@"colorType"];
        }else if (type==0) {
            int colorType=[[theObject objectForKey:@"colorType"] intValue];
            [theObject setObject:colorType==0 ? @1:@0 forKey:@"colorType"];
        }
    }
}

-(void) showTheLights
{
    for (int i=0; i<_theLightsArray.count; i++) {
        NSMutableDictionary *theObject = _theLightsArray[i];
        UIImageView *theView = (UIImageView *)[self viewWithTag:[[theObject objectForKey:@"tag"] intValue]];
        theView.image=[self getImageWithType:[[theObject objectForKey:@"type"] intValue] andImageType:[[theObject objectForKey:@"colorType"] intValue]];
    }
}

-(UIImage *) getImageWithType:(int) lightType andImageType:(int) imageType
{
    UIImage *image=nil;
    if (lightType==1) {
        switch (imageType) {
            case 1:
                image=[UIImage imageNamed:@"light_blue"];
                break;
            case 2:
                image=[UIImage imageNamed:@"light_purple"];
                break;
            case 3:
                image=[UIImage imageNamed:@"light_green"];
                break;
            case 4:
                image=[UIImage imageNamed:@"light_red"];
                break;
            case 5:
                image=[UIImage imageNamed:@"light_yellow"];
                break;
            default:
                image=[UIImage imageNamed:@"light_blue"];
                break;
        }
    }else if (lightType==0){
        if (imageType==1) {
            image=[UIImage imageNamed:@"light_small_yellow"];
        }else{
            image=[UIImage imageNamed:@"light_small_grey"];
        }
    }
    return image;
}


-(void) stopLightingAnimation
{
    [_timer invalidate];
    _timer = nil;
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
