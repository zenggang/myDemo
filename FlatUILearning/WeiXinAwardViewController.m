//
//  WeiXinAwardViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-9.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "WeiXinAwardViewController.h"

@interface WeiXinAwardViewController()
{
    
}

@property (nonatomic,weak) IBOutlet UITextView *describeView;
@property (nonatomic,weak) IBOutlet UIScrollView *mainScrollView;
@end
@implementation WeiXinAwardViewController

-(void)viewDidLoad
{
    if (_describeType==DescribeTypeWeiXin) {
        self.title=@"微信关注奖励";
        _mainScrollView.contentSize=CGSizeMake(320, 1000);
    }else{
        self.title=@"评5星送积分";
        [[_mainScrollView viewWithTag:1] removeFromSuperview];
        [[_mainScrollView viewWithTag:2] removeFromSuperview];
        [[_mainScrollView viewWithTag:3] removeFromSuperview];
        _describeView.text=@"去AppStore评完5星可以把绑定QQ号发送给微信公共账号或者联系QQ客服(2517481594),并说明是评分奖励,客服根据评价送出一定金额的奖励!";
        _mainScrollView.contentSize=CGSizeMake(320, mainScreenHeightWithoutBar);
        
        [_mainScrollView addSubview:[self createFUIButtonWithFrame:CGRectMake(20, 130, 280, 40) cornerRadius:2 clickAction:@selector(fiveStarAction) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"去AppStroe评分"]];
    }
    
    self.view.backgroundColor=[UIColor cloudsColor];
    _describeView.font = [UIFont boldFlatFontOfSize:17];
    _describeView.textColor=GREEN_COLOR;
    
    
}

-(void) fiveStarAction
{
    NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"675526778"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
