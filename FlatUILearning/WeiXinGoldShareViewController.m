//
//  WeiXinGoldShareViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-11.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "WeiXinGoldShareViewController.h"
#import "TTDate.h"
#import "UserGold.h"
#import "UserGetGoldDetail.h"

#define SHOULD_SEND_TEN_GOLD_TAG  564

@interface WeiXinGoldShareViewController ()

@property (nonatomic,weak) IBOutlet UIView *shareContainerView;
@property (nonatomic,strong) UIButton *shareButton;
@property (nonatomic,weak) IBOutlet UILabel *describeLable;
@property (nonatomic,weak) IBOutlet UILabel *getGoldLable;
@property (nonatomic,strong) NSMutableArray *getGoldArray;
@property (nonatomic,strong) NSMutableArray *allArray;

@property (nonatomic,weak) IBOutlet UILabel *showTimeLable;
@property (nonatomic,weak) IBOutlet UILabel *showGoldLable;
@property (nonatomic,weak) IBOutlet UILabel *showMoneyLable;
@property (weak, nonatomic) IBOutlet FUISegmentedControl *flatSegmentedControl;


@property (nonatomic,weak) IBOutlet UILabel *countLable1;
@property (nonatomic,weak) IBOutlet UILabel *countLable2;
@property (nonatomic,weak) IBOutlet UILabel *countLable3;
@property (nonatomic,weak) IBOutlet UILabel *countLable4;
@property (nonatomic,weak) IBOutlet UILabel *countLable5;

@property (nonatomic,strong) NSString *shareKey;

@end

@implementation WeiXinGoldShareViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    if (_scene==WXSceneSession) {
        self.title=@"分享给微信朋友";
        _shareKey=[NSString stringWithFormat:@"shareGoldToFriend_%@",[TTDate dateString:[NSDate date] dateFormatter:dateFormatterUntilDD]];
    }else{
        self.title=@"分享到微信朋友圈";
        _shareKey=[NSString stringWithFormat:@"shareGoldToTimeLine_%@",[TTDate dateString:[NSDate date] dateFormatter:dateFormatterUntilDD]];
    }
    _weixinController =[[BaseWeiXInController alloc] init];
    _weixinController.delegate=self;
    [_weixinController changeScene:_scene];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _shareContainerView.backgroundColor=GREEN_COLOR;
    
    
    _shareButton=[self createFUIButtonWithFrame:CGRectMake(10, mainScreenHeightWithoutBar-50, 300, 40) cornerRadius:2 clickAction:@selector(sendImageToWeiXin) fontSize:[UIFont boldFlatFontOfSize:17] buttonColor:nil shadowColor:nil titleColor:nil withText:self.title];
    [self.view addSubview:_shareButton];
    
    _describeLable.textColor=GREEN_COLOR;
    _describeLable.font=[UIFont flatFontOfSize:15];
    for (int i=1; i<=5; i++) {
        UILabel *lable=(UILabel *) [_shareContainerView viewWithTag:i];
        switch (i) {
            case 1:
                lable.font=[UIFont boldFlatFontOfSize:17];
                break;
            case 2:
            case 3:
            case 5:
                lable.font=[UIFont flatFontOfSize:13];
                break;
                case 4:
                lable.font=[UIFont boldFlatFontOfSize:33];
                break;
            default:
                break;
        }
    }
    
    for (int i=551; i<=555; i++) {
        UILabel *lable=(UILabel *) [_shareContainerView viewWithTag:i];
        lable.textColor=APPDELEGATE.sysButtonShadowColor;
    }
    
    NSString *shareState=[[NSUserDefaults standardUserDefaults] objectForKey:_shareKey];
    if (shareState) {
        _getGoldLable.textColor=[UIColor redColor];
        _getGoldLable.text=@"*今日奖励已领取!";
    }else
        _getGoldLable.textColor=GREEN_COLOR;
    
    _getGoldLable.font=[UIFont flatFontOfSize:15];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [UserGetGoldDetail getUserGetGoldLogOnSuccess:^(NSMutableArray *array) {
        [SVProgressHUD dismiss];
        _allArray=array;
        _getGoldArray=[NSMutableArray array];
        [self changeLineByDayCount:1];
    } failure:^(id error) {
        [AppUtilities handleErrorMessage:error];
    } pageNo:1];
    
    self.flatSegmentedControl.selectedFont = [UIFont boldFlatFontOfSize:16];
    self.flatSegmentedControl.selectedFontColor = [UIColor whiteColor];
    self.flatSegmentedControl.deselectedFont = [UIFont flatFontOfSize:16];
    self.flatSegmentedControl.deselectedFontColor = [UIColor whiteColor];
    self.flatSegmentedControl.selectedColor = GREEN_COLOR;
    self.flatSegmentedControl.deselectedColor = [UIColor silverColor];
    self.flatSegmentedControl.dividerColor = CELL_SELECT_COLOR;
    self.flatSegmentedControl.cornerRadius = 1.0;
    [_flatSegmentedControl addTarget:self
                              action:@selector(changTimeOp:)
                    forControlEvents:UIControlEventValueChanged];
}

-(void)sendImageToWeiXin
{
    UIImage *myImage =[AppUtilities getImageFromUIView:_shareContainerView];
    NSData *thumbData=UIImageJPEGRepresentation(myImage, 0.2);
    NSData *dataimageData=UIImageJPEGRepresentation(myImage, 1);
    [_weixinController sendImageContentWithThumbData:thumbData withImageData:dataimageData];
}




#pragma mark sendMsgToWeChatViewDelegate

-(void) didSendMessageSuccess
{
    NSString *shareState=[[NSUserDefaults standardUserDefaults] objectForKey:_shareKey];
    if (shareState) {
        [self showFUIAlertViewWithTitle:@"消息" message:@"分享成功!" withTag:-1 cancleButtonTitle:@"好的" otherButtonTitles:nil];
    }else{
        _getGoldLable.textColor=[UIColor redColor];
        _getGoldLable.text=@"*今日奖励已领取!";
        [[NSUserDefaults standardUserDefaults] setValue:@"done" forKey:_shareKey];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        [self showFUIAlertViewWithTitle:@"恭喜!分享成功!" message:@"分享成功,您将获得系统赠送的3金币!" withTag:SHOULD_SEND_TEN_GOLD_TAG cancleButtonTitle:@"确认收取" otherButtonTitles:nil];
    }
}
 
-(void) didSendMessageError
{
    [self showFUIAlertViewWithTitle:@"很遗憾!" message:@"分享失败,请重试!" withTag:-1 cancleButtonTitle:@"知道了" otherButtonTitles:nil];
}

#pragma mark function

-(void) changeLineByDayCount:(int) dayCount
{
    int totalGold = 0;
    [_getGoldArray removeAllObjects];

    NSDate *now =[NSDate date];
    for (int i=0; i<_allArray.count; i++) {
        UserGetGoldDetail *getGold=_allArray[i];
        if (dayCount<4) {
            NSTimeInterval t =[[TTDate dateWithString:getGold.postDate dateFormatter:dateFormatterUntilSSS] timeIntervalSinceDate:now];
            int time = [[NSNumber numberWithDouble:t] intValue]*-1;
            if (time<86400*dayCount) {
                [_getGoldArray addObject:getGold];
                totalGold+=getGold.goldAmount;
                
            }
        }else{
            [_getGoldArray addObject:getGold];
            totalGold+=getGold.goldAmount;
        } 
        
    }
    
    _showGoldLable.text=[NSString stringWithFormat:@"收入:%d金币",totalGold];
    _showMoneyLable.text=[NSString stringWithFormat:@"%.2f",totalGold*0.01];
    if(dayCount<4)
        _showTimeLable.text=[NSString stringWithFormat:@"%d小时收入一览",dayCount*24];
    else
        _showTimeLable.text=@"近期收入一览";
    
    
    switch (_getGoldArray.count) {
        case 0:
        {
            [self setCountLableStringWithNo2:0 No3:0 No4:0 No5:0];
        }
        case 1:
        {
            [self setCountLableStringWithNo2:0 No3:0 No4:0 No5:0];
        }
            break;
        case 2:
        {
            [self setCountLableStringWithNo2:0 No3:0 No4:0 No5:2];
        }
            break;
        case 3:
        {
            [self setCountLableStringWithNo2:0 No3:2 No4:0 No5:3];
        }
            break;
        case 4:
        {
            [self setCountLableStringWithNo2:2 No3:0 No4:3 No5:4];
        }
            break;
        case 5:
        {
            [self setCountLableStringWithNo2:2 No3:3 No4:4 No5:5];
        }
            break;
            
        default:{
            float s =_getGoldArray.count*0.25;
            [self setCountLableStringWithNo2:ceil(s) No3:ceil(s*2) No4:ceil(s*3) No5:_getGoldArray.count];
        }
            break;
    }
    
    [self drawScoreLine];
}


-(void) setCountLableStringWithNo2:(int) No2 No3:(int) No3 No4:(int) No4
No5:(int) No5
{
    if(_getGoldArray.count>0)
        _countLable1.text=@"1";
    else
        _countLable1.text=@"";
    _countLable2.text=(No2==0 ? @"":[NSString stringWithFormat:@"%d",No2]);
    _countLable3.text=(No3==0 ? @"":[NSString stringWithFormat:@"%d",No3]);
    _countLable4.text=(No4==0 ? @"":[NSString stringWithFormat:@"%d",No4]);
    _countLable5.text=(No5==0 ? @"":[NSString stringWithFormat:@"%d",No5]);
}

-(void) drawScoreLine
{
    [[_shareContainerView viewWithTag:897] removeFromSuperview];
    
    if ([_getGoldArray count]>0) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(40, 55, 240,120)];
        imageView.tag=897;
        [_shareContainerView addSubview:imageView];
        
        
        UIGraphicsBeginImageContext(imageView.frame.size);
        [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.5);
        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
        //        CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 255/255.0, 255/255.0, 255/255.0,1.0);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        
        float sprate=240.0;
        if([_getGoldArray count]>1)
            sprate=240/([_getGoldArray count]-1);
        
        for (int i=[_getGoldArray count]-1; i>=0; i--) {
            UserGetGoldDetail *getGold=_getGoldArray[i];
            int y= 120 - getGold.goldAmount < 5  ? 5 : 120 - getGold.goldAmount ;
            float x=[_getGoldArray count]==1 ? 5 :240-i*sprate;
            if (i==([_getGoldArray count]-1)) {
                CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x, y);
                if(_getGoldArray.count==1)
                    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),  x, y);
            } else {
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),  x, y);
            }
        }
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        imageView.image=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

-(void) changTimeOp:(FUISegmentedControl *) sender
{
    [self changeLineByDayCount:sender.selectedSegmentIndex+1];
}


-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==SHOULD_SEND_TEN_GOLD_TAG) {
        [SVProgressHUD showWithStatus:@"收取中!"];
        NSString *type =@"shareGoldToTimeLine";
        if (_scene==WXSceneSession) {
            type =@"shareGoldToFriend";
        }
        [UserGold getWeixinAwardWithType:type OnSuccess:^(id json) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功收取%@金币!",[json objectForKey:@"amount"]]];
        } failure:^(id error) {
            [AppUtilities handleErrorMessage:error];
        }];
    }
}

@end
