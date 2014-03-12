//
//  GuagualeViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-20.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GuagualeViewController.h"
#import "SVPullToRefresh.h"
#import "GuaGuaKa.h"
#import "GuaGuaKaLogViewController.h"


#define GOLD_NOT_ENOUGH_ALERT_TAG 2348
#define GOLD_OVER_100_ALERT_TAG 2349
@interface GuagualeViewController ()
{
}

@property (nonatomic,weak) IBOutlet UILabel *goldLable;
@property (nonatomic,weak) IBOutlet UIView *goldMainView;

@property (nonatomic,strong) FUIButton *goldButton;
@property (nonatomic,strong) FUIButton *exchangeButton;

@property (nonatomic,assign) int awardValue;
@property (nonatomic,assign) int benjin;
@property (nonatomic,assign) int theGid;
@property (nonatomic,assign) BOOL isScratched;
@property (nonatomic,strong) DMScrollingTicker *scrollTextView;
-(void) buildScrollTextView;
//-(void) showTheTickesWithBenjin:(int) benjin;
-(BOOL) checkUnScratchTickes;
@end

@implementation GuagualeViewController


-(void)viewDidLoad
{
    
    self.title=@"金币刮刮赚";
    [self createNavigationLeftButtonWithTitle:@"菜单"  action:@selector(showMenuLeft)];
    [self createNavigationRightButtonWithTitle:@"记录" action:@selector(showMenuRight)];
    _goldLable.textColor=[UIColor colorFromHexCode:@"f1c40f"];
    _isScratched=YES;
    [_goldMainView setBackgroundColor:[UIColor midnightBlueColor]];
    if ([AppUtilities isIOS7]) {
         self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont: [UIFont boldFlatFontOfSize:18],UITextAttributeTextColor:[UIColor whiteColor]};
        [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    }else{
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont: [UIFont boldFlatFontOfSize:18]};
        [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (APPDELEGATE.appVersionInfo) {
        [_goldLable setText:[NSString stringWithFormat:@"金币:%d",APPDELEGATE.userGoldAmont ]];
        [super viewDidLoad];
        if (APPDELEGATE.appVersionInfo.isHide==1) {
            _exchangeButton.hidden=YES;
        }
    }else{
        [SVProgressHUD showWithStatus:@"数据加载中..."];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delayInitViewDidLoad) name:APPINFO_DID_LOADED object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildScrollTextView) name:STRING_ARRAY_FOR_WALL_LOADED object:nil];
    
    

    _carouseView.delegate=self;
    _carouseView.dataSource=self;
    _carouseView.type = iCarouselTypeCoverFlow2;
    _carouseView.scrollSpeed=0.7f;
    _carouseView.bounceDistance=0.4f;
    _carouseView.decelerationRate=0.8f;
    _carouseView.vertical = YES;
    _carouseView.clipsToBounds=YES;
    
    

    _goldButton =[self createFUIButtonWithFrame:CGRectMake(220, 10, 90, 35) cornerRadius:3 clickAction:@selector(toGetGold) fontSize:[UIFont flatFontOfSize:15] buttonColor:[UIColor peterRiverColor] shadowColor:[UIColor midnightBlueColor] titleColor:[UIColor whiteColor] withText:@"免费赚金币"];
    [_goldMainView addSubview:_goldButton];
    
    _exchangeButton =[self createFUIButtonWithFrame:CGRectMake(120, 10, 90, 35) cornerRadius:3 clickAction:@selector(toExchangeMoney) fontSize:[UIFont flatFontOfSize:15] buttonColor:[UIColor peterRiverColor] shadowColor:[UIColor midnightBlueColor] titleColor:[UIColor whiteColor] withText:@"兑换现金"];
    [_goldMainView addSubview:_exchangeButton];
    if (APPDELEGATE.appVersionInfo.isHide==1) {
        _exchangeButton.hidden=YES;
    }
    
    [GuaGuaKa getGuaGuaKaListOnSuccess:^(id respons) {
        self.dataArray=respons;
        [_carouseView reloadData];
        [self buildScrollTextView];
        if (IS_IPHONE5) {
            [_carouseView scrollToItemAtIndex:2 animated:YES];
        }else
            [_carouseView scrollToItemAtIndex:1 animated:YES];
        
    } failure:^(id error) {
        [AppUtilities handleErrorMessage:error];
    }];
    
}

-(void)didReceiveAdView:(UIView*)adView
{
    [super didReceiveAdView:adView];
    if(self.dianruBannarView)
    {
        self.dianruBannarView.center=CGPointMake(160, 23);
    }
}

#pragma mark ---customer Actions
-(void) afterGoldReloaded
{
    [super afterGoldReloaded];
    [_goldLable setText:[NSString stringWithFormat:@"金币:%d",APPDELEGATE.userGoldAmont ]];
}



-(void) delayInitViewDidLoad
{
    if (APPDELEGATE.appVersionInfo.isHide==1) {
        _exchangeButton.hidden=YES;
    }
    [SVProgressHUD dismiss];
    [_goldLable setText:[NSString stringWithFormat:@"金币:%d",APPDELEGATE.userGoldAmont ]];
    [super viewDidLoad];
    
}

-(void) checkGoldToBuyTicket:(int) benjin  andGid:(int) gid
{
    
    if (APPDELEGATE.userGoldAmont<benjin) {
        [self showFUIAlertViewWithTitle:@"提示!" message:@"您金币不足,快去获得更多金币吧!" withTag:GOLD_NOT_ENOUGH_ALERT_TAG cancleButtonTitle:@"好的!" otherButtonTitles:nil];
        return;
    }
    _benjin=benjin;
    _theGid=gid;
    if (benjin>=100) {
        [self showFUIAlertViewWithTitle:@"提示!" message:[NSString stringWithFormat:@"您确定要购买%d金币的刮刮卡吗?",benjin] withTag:GOLD_OVER_100_ALERT_TAG cancleButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        return;
    }
    
    [self afterTicketBought];
}

-(void) afterTicketBought
{
    _isScratched=NO;
    [AppUtilities showHUDWithStatus:@"购买中..."];
    [GuaGuaKa buyGuaGuaKaWithGid:_theGid OnSuccess:^(id respons) {
        [AppUtilities dismissHUD];
        [(TicketView *)_carouseView.currentItemView showTheTicketScratchArea];
        [(TicketView *)_carouseView.currentItemView setResultValue:[[respons objectForKey:@"resultValue"] integerValue]];
        [_goldLable setText:[NSString stringWithFormat:@"金币:%d",APPDELEGATE.userGoldAmont-_benjin ]];
        APPDELEGATE.userGoldAmont=[[respons objectForKey:@"goldAmount"] integerValue];
    } failure:^(id error) { 
        [AppUtilities handleErrorMessage:error];
    }];
}

-(void) toGetGold
{
    if (![self checkUnScratchTickes]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_VIEW_TO_IDENTIFIER object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"GetGoldViewController",@"identifier",nil]];
}
-(void) toExchangeMoney
{
    if (![self checkUnScratchTickes]) {
        return;
    }
    [[NSNotificationCenter defaultCenter]  postNotificationName:CHANGE_VIEW_TO_IDENTIFIER object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"goldExchangeViewController",@"identifier",nil]];
}
-(BOOL) checkUnScratchTickes
{
    if(_isScratched){
        return YES;
    }else{
        [self showFUIAlertViewWithTitle:@"提示!" message:@"您上一张卡还没刮,快先刮完!" withTag:-1 cancleButtonTitle:@"好的!" otherButtonTitles:nil];
        return NO;
    }
}

-(void) buildScrollTextView
{
    if (APPDELEGATE.appVersionInfo && APPDELEGATE.appVersionInfo.isHide==0) {
        if (_scrollTextView) {
            [_scrollTextView removeFromSuperview];
        }
        NSArray *textArray=APPDELEGATE.exchangeArrayForWall;
        _scrollTextView =[self createTextScrollViewWithFrame:CGRectMake(0, 0, 320, 20) withTextArray:textArray];
        _scrollTextView.tag=786;
        [self.view addSubview:_scrollTextView];
    }
}

#pragma mark TicketViewDelegate
-(void) didScratchTicket
{
    _isScratched=YES;
    _carouseView.scrollEnabled=YES;
    [_goldLable setText:[NSString stringWithFormat:@"金币:%d",APPDELEGATE.userGoldAmont]];
}

-(void) clickTheBuyButtonwithGid:(int) gid  withBenJin:(int) benjin
{
    [self checkGoldToBuyTicket:benjin andGid:gid];
}

#pragma mark system
-(void)viewWillUnload
{
    [super viewWillUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPINFO_DID_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:STRING_ARRAY_FOR_WALL_LOADED];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    }
    if (![self.slidingViewController.underRightViewController isKindOfClass:[GuaGuaKaLogViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"guaGuaKaLogViewController"];
    }
    
}
/**
 显示左侧
 */
-(void) showMenuLeft
{
    if (![self checkUnScratchTickes]) {
        return;
    } 
    [super showMenuLeft];
}
-(void) showMenuRight
{
    if (![self checkUnScratchTickes]) {
        return;
    }
    [super showMenuRight];
}

#pragma mark alert
-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag==GOLD_NOT_ENOUGH_ALERT_TAG) {
        
    } else if(alertView.tag==GOLD_OVER_100_ALERT_TAG) {
        if (buttonIndex==0) {
            [(TicketView *)_carouseView.currentItemView showTheTicketScratchArea];
            [self afterTicketBought];
        }
    }
}

#pragma mark iCarousel



-(NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.dataArray.count;
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    GuaGuaKa *guaguaka=[self.dataArray objectAtIndex:index];
    if (!view) {
        view= [self loadViewFromXibName:@"TicketView"];
    }
    TicketView  *ticketView =(TicketView *)view;
    [ticketView setUpTicketWithinfo:guaguaka withTicketViewDelegate:self];
    
    return ticketView; 
}


- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    for (TicketView *tView in [_carouseView visibleItemViews]) {
        if (![tView isEqual:[_carouseView currentItemView]]) {
            [tView changeTicketToBeforeModel];
        }else{
             [tView changeTicketToBuyModel];
        }
    }
}

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index
{
    if (!_isScratched) {
        carousel.scrollEnabled=NO;
        return NO;
    }else
        return YES;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 220;
}
- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carouseView.itemWidth);
}


- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option==iCarouselOptionTilt) {
        return 0.63;
    }else if (option==iCarouselOptionVisibleItems){
        if (IS_IPHONE5) {
            return 5;
        }else
            return 3;
    }else if (option==iCarouselOptionWrap){
        return NO;
    }
    return value;
}

-(void) testCard
{
    int addTime=0;
    int cutTime =0;
    int benjinx=1000;
    for (int i=0;i<20; i++) {
        int result = [self calculateCardValueWithBaobenRate:0.55 andBenJin:100];
        benjinx-=100;
        if (result>100) {
            addTime++;
        }
        if (result<100) {
            cutTime++;
        }
        benjinx+=result;
        NSLog(@"%d",result);
        if (benjinx<0) {
            break;
        }
    }
    
    NSLog(@"add %d  cut %d result:%d",addTime,cutTime,benjinx);
    
}


-(int) calculateCardValueWithBaobenRate:(double) baobenRate andBenJin:(int) benjin
{
    double awardRate=(1-baobenRate)*0.5;
    double loseRate=awardRate*2;
    double equalRate=1-awardRate-loseRate;
    int k=5;
    if (benjin>=100) {
        k=10;
        if (benjin>=200) {
            k=20;
        }
    }
    
    double rate =arc4random_uniform(1000) / 1000.0;
    int kRate=arc4random_uniform(k)+1;
    int kValue=(benjin/k)*kRate;
    if (rate<=loseRate) {
        if (benjin>=200) {
            return benjin-(kValue*1.1) < 0 ? 0: benjin-(kValue*1.1);
        }else
            return benjin-kValue;
    } else if(rate<=(loseRate+equalRate)){
        return benjin;
    }else{
        if (benjin>=200) {
            return benjin+(kValue*1.01);
        }else{
            return benjin+(kValue*1.1);
        }
        
    }
    
}


@end
