//
//  WeiXinAwardViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-9.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "WeiXinAwardViewController.h"
#import "AppUtilities.h"

@interface WeiXinAwardViewController()
{
    
}

@property (nonatomic,weak) IBOutlet UITextView *describeView;
@property (nonatomic,weak) IBOutlet UIScrollView *mainScrollView;
@end
@implementation WeiXinAwardViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    if (_describeType==DescribeTypeWeiXin) {
        self.title=@"微信关注奖励";
        _mainScrollView.contentSize=CGSizeMake(320, 1000);
    }else if(_describeType ==DescribeTypeFiveStar){
        self.title=@"评5星送积分";
        [[_mainScrollView viewWithTag:1] removeFromSuperview];
        [[_mainScrollView viewWithTag:2] removeFromSuperview];
        [[_mainScrollView viewWithTag:3] removeFromSuperview];
        _describeView.text=@"去AppStore评完5星可以把绑定QQ号发送给微信公共账号,并说明是评分奖励,客服根据评价送出一定金额的奖励!(如果是ios7用户,会稍微繁琐一些,请在'评论'栏下方点击'撰写评论'按钮)";
        _mainScrollView.contentSize=CGSizeMake(320, mainScreenHeightWithoutBar);
        
        [_mainScrollView addSubview:[self createFUIButtonWithFrame:CGRectMake(20, 130, 280, 40) cornerRadius:2 clickAction:@selector(fiveStarAction) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:@"去AppStroe评分"]];
    }else if (_describeType==DescribeTypeShareToFriens)
    {
        self.title=@"快速安装程序";
        UIImageView *shareImageView = (UIImageView *)[_mainScrollView viewWithTag:1];
        shareImageView.frame =CGRectMake(76, 130, 168, 168);
        shareImageView.image=[UIImage imageNamed:@"sharePic"];
        [[_mainScrollView viewWithTag:2] removeFromSuperview];
        [[_mainScrollView viewWithTag:3] removeFromSuperview];
        _describeView.text=@"推荐给朋友安装后记得要到对方的绑定QQ号,每次最多可领取50金币哦,兑换次数无限制!让对方打开微信,用扫一扫对准下面的二维码图片,就可以安装了!";
        _mainScrollView.contentSize=CGSizeMake(320, mainScreenHeightWithoutBar);

    }
    
    self.view.backgroundColor=[UIColor cloudsColor];
    _describeView.font = [UIFont boldFlatFontOfSize:17];
    _describeView.textColor=GREEN_COLOR;
    
    
}

-(void) fiveStarAction
{
    
    NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"675526778"];
    if ([AppUtilities isIOS7 ]) {
        str=@"https://itunes.apple.com/cn/app/mai-dang-lao-you-hui-juan/id675526778?ls=1&mt=8";
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
