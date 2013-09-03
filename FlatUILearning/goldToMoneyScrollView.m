//
//  goldToMoneyScrollView.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-28.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "goldToMoneyScrollView.h"

@implementation goldToMoneyScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setUpTextScrollView:(NSArray *) array
{
    _textArray=array;
    for (int i=0; i<7; i++) {
        UILabel *lable =(UILabel *)[self viewWithTag:i+1];
        lable.text=_textArray[i];
        lable.font=[UIFont boldFlatFontOfSize:15];
        lable.textColor=[UIColor whiteColor];
    }
    _lastIndex=7; 

    [self startScrollAnimetion];
}


-(void) startScrollAnimetion
{
    if (!_stopAnimation) {
        __weak __typeof(&*self)weakSelf = self;
        [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            for (int i=0; i<7; i++) {
                UILabel *lable =(UILabel *)[weakSelf viewWithTag:i+1];
                lable.frame=CGRectMake(lable.frame.origin.x, lable.frame.origin.y-22, lable.frame.size.width, lable.frame.size.height);
            }
        } completion:^(BOOL finished) {
            UILabel *firstlable =(UILabel *)[weakSelf viewWithTag:1];
            firstlable.frame=CGRectMake(firstlable.frame.origin.x, firstlable.frame.origin.y+(22*7), firstlable.frame.size.width, firstlable.frame.size.height);
            for (int i=2; i<8; i++) {
                UILabel *lable =(UILabel *)[weakSelf viewWithTag:i];
                lable.tag=i-1;
            }
            firstlable.tag=7;
            [firstlable setText:_textArray[_lastIndex]];
            if (_lastIndex==_textArray.count-1) {
                _lastIndex=0;
            }else{
                _lastIndex++;
            }
            [weakSelf startScrollAnimetion];
        }];
    }

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
