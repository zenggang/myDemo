//
//  YaoQianZuanViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 14-5-10.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import "YaoQianZuanViewController.h"
#import "TouziType.h"

@interface YaoQianZuanViewController ()


@property (nonatomic,weak) IBOutlet  UIButton *startButton;
@property (nonatomic,weak) IBOutlet  UIButton *betOneButton;
@property (nonatomic,weak) IBOutlet  UIButton *betTenutton;
@property (nonatomic,weak) IBOutlet  UIButton *exchangeButton;
@property (nonatomic,weak) IBOutlet  UIButton *getGoldButton;

@property (nonatomic,weak) IBOutlet UIImageView *lineBreakImageView;
@property (nonatomic,weak)   FBLCDFontView *mainGoldLable;
@property (nonatomic,weak)   FBLCDFontView *coinGoldLable;
@property (nonatomic,weak)  IBOutlet UIImageView *mainGoldLableBgImageView;
@property (nonatomic,weak) IBOutlet  UIImageView *coinGoldLableBgImageView;
@property (nonatomic,weak) IBOutlet UIImageView *backGroudImageView;
@property (nonatomic,strong) DMScrollingTicker *scrollTextView;


@property (nonatomic,strong) UIImageView *backgroudImageView;

@property (nonatomic,assign) int coinAmount;
@property (nonatomic,assign) NSInteger totalAmount;
@property (nonatomic,assign) int awardGoldAmount;
@property (nonatomic,strong) coinView *dropCoinView;

@property (nonatomic,strong)  customSwitchButton *musicSwitchButton;
@property (nonatomic,strong)  customSwitchButton *soundSwitchButton;
@property (nonatomic,weak) IBOutlet UIImageView *musicText;
@property (nonatomic,weak) IBOutlet UIImageView *soundText;
@property (nonatomic,strong) RollingBoxView *rollingBoxView;

-(void) toExchangeMoney;
-(void) toGetGold; 
-(void) showBannerAd;
-(void)buildScrollTextView;
@end
#define GET_GOLD_ALERT_TAG 4563

@implementation YaoQianZuanViewController{
@private
    
    NSArray *_slotIcons;
    
    AVAudioPlayer *beforeSpinSoundplayer;
    AVAudioPlayer *spinSoundplayer;
    AVAudioPlayer *dropCpinSoundplayer;
    AVAudioPlayer *winTwoSoundplayer;
    AVAudioPlayer *winThreeSoundplayer;
    AVAudioPlayer *bgSoundplayer;
    AVAudioPlayer *exChangeSoundplayer;
    BOOL isBigWin;
    BOOL isSmallWin;
    int oneCoinWorth;
    int awardTimes;
}

#pragma mark - View LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _slotIcons = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"lucky_seven"], [UIImage imageNamed:@"lucky_orange"], [UIImage imageNamed:@"lucky_grape"],[UIImage imageNamed:@"lucky_cherry"],[UIImage imageNamed:@"lucky_banana"], [UIImage imageNamed:@"lucky_ watermelon"], nil];
    }
    return self;
}


- (void)dealloc {
    [_startButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    _dropCoinView=nil;
    
}


- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    isHideStatusBar=YES;
	oneCoinWorth=10;
    self.wantsFullScreenLayout = YES;
    
    
    //转盘view
//    
//    _zuanPanView = [AppUtilities loadViewFromNibNamed:@"ZuanPanView"];
//    _zuanPanView.center=CGPointMake(160, 198);
//    [self.view addSubview:_zuanPanView];
//    _zuanPanView.delegate=self;
//    
//    [Dazuanpan getDazuanpanListOnSuccess:^(id list) {
//        NSMutableArray *typeList=list;
//        //[_zuanPanView setUpZuanPanViewWithTypeList:typeList];
//        [self buildScrollTextView];
//    } failure:^(id error) {
//        
//    }];
    
    _rollingBoxView= [AppUtilities loadViewFromNibNamed:@"RollingBoxView"];
    _rollingBoxView.center=CGPointMake(160, 198);
    [_rollingBoxView setupRollingView];
    _rollingBoxView.delegate=self;
    [self.view addSubview:_rollingBoxView];
    
    //各种按钮
    [_startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [_betOneButton addTarget:self action:@selector(addCoin:) forControlEvents:UIControlEventTouchUpInside];
    [_betTenutton addTarget:self action:@selector(addCoin:) forControlEvents:UIControlEventTouchUpInside];
    //switch
    _musicSwitchButton =[AppUtilities loadViewFromNibNamed:@"customSwitchButton"];
    _soundSwitchButton =[AppUtilities loadViewFromNibNamed:@"customSwitchButton"];
    _musicSwitchButton.delegate=self;
    _soundSwitchButton.delegate=self;
    _musicSwitchButton.frame=CGRectMake(21, 458, 61, 32);
    _soundSwitchButton.frame=CGRectMake(21, 498, 61, 32);
    [self.view addSubview:_musicSwitchButton];
    [self.view addSubview:_soundSwitchButton];
    [_musicSwitchButton setUpSwitchButtonWithOn:APPDELEGATE.isAllowMusic];
    [_soundSwitchButton setUpSwitchButtonWithOn:APPDELEGATE.isAllowSound];
    
    //lable背景
    UIEdgeInsets insets = UIEdgeInsetsMake(20, 20, 20, 20);
    UIImage *lableBgImage=[UIImage imageNamed:@"number_bg"];
    lableBgImage=[lableBgImage resizableImageWithCapInsets:insets];
    _coinGoldLableBgImageView.image=lableBgImage;
    _mainGoldLableBgImageView.image=lableBgImage;
    _mainGoldLable=[self CreateLCDFontWithFrame:_mainGoldLableBgImageView.frame withTxt:@"000000"];
    _coinGoldLable=[self CreateLCDFontWithFrame:_coinGoldLableBgImageView.frame withTxt:@"000"];
    
    [self.view addSubview:_mainGoldLable];
    [self.view addSubview:_coinGoldLable];
    if (IS_IPHONE5) {
        [_coinGoldLableBgImageView setFrameOrigin:CGPointMake(15, 371)];
        [_mainGoldLableBgImageView setFrameOrigin:CGPointMake(104, 371)];
        [_mainGoldLable setFrameOrigin:CGPointMake(118, 378)];
        [_coinGoldLable setFrameOrigin:CGPointMake(26, 378)];
        [_startButton setFrameOrigin:CGPointMake(235, 404)];
        [_betOneButton setFrameOrigin:CGPointMake(17, 437)];
        [_betTenutton setFrameOrigin:CGPointMake(117, 437)];
        [_lineBreakImageView setFrameOrigin:CGPointMake(0, 498)];
        
        [_exchangeButton setFrameOrigin:CGPointMake(141, 515)];
        [_getGoldButton setFrameOrigin:CGPointMake(238, 515)];
        [_musicSwitchButton setFrameOriginY:503];
        [_soundSwitchButton setFrameOriginY:535];
        [_musicText setFrameOriginY:509];
        [_soundText setFrameOriginY:536];
    }else {
        _rollingBoxView.center=CGPointMake(160, 169);
        [_startButton setFrameOrigin:CGPointMake(235, 330)];
        [_betOneButton setFrameOrigin:CGPointMake(17, 363)];
        [_betTenutton setFrameOrigin:CGPointMake(117, 363)];
        [_lineBreakImageView setFrameOrigin:CGPointMake(0, 413)];
        
        [_exchangeButton setFrameOrigin:CGPointMake(141, 430)];
        [_getGoldButton setFrameOrigin:CGPointMake(238, 430)];
        [_coinGoldLableBgImageView setFrameOrigin:CGPointMake(15, 308)];
        [_mainGoldLableBgImageView setFrameOrigin:CGPointMake(104, 308)];
        [_musicSwitchButton setFrameOriginY:416];
        [_soundSwitchButton setFrameOriginY:448];
        [_musicText setFrameOriginY:424];
        [_soundText setFrameOriginY:451];
        [_mainGoldLable setFrameOrigin:CGPointMake(118, 315)];
        [_coinGoldLable setFrameOrigin:CGPointMake(26, 315)];
        _backGroudImageView.image=[UIImage imageNamed:@"yaoqianzuan_iphone4_bg" ];
    }
    
    
    beforeSpinSoundplayer=[self setAudioPlay:beforeSpinSoundplayer WithSoundFileName:@"beforeSping2" offileType:@"wav" numberOfLoops:0 volume:0.2];
    spinSoundplayer=[self setAudioPlay:spinSoundplayer WithSoundFileName:@"spinging" offileType:@"wav" numberOfLoops:0 volume:0.4];
    dropCpinSoundplayer=[self setAudioPlay:dropCpinSoundplayer WithSoundFileName:@"dropCoin1" offileType:@"wav" numberOfLoops:0 volume:0.4];
    winTwoSoundplayer=[self setAudioPlay:winTwoSoundplayer WithSoundFileName:@"winTwo" offileType:@"wav" numberOfLoops:0 volume:0.5];
    winThreeSoundplayer =[self setAudioPlay:winThreeSoundplayer WithSoundFileName:@"winThree" offileType:@"wav" numberOfLoops:0 volume:0.5];
    bgSoundplayer=[self setAudioPlay:bgSoundplayer WithSoundFileName:@"loopj" offileType:@"wav" numberOfLoops:-1 volume:0.2];
    exChangeSoundplayer=[self setAudioPlay:exChangeSoundplayer WithSoundFileName:@"exchange" offileType:nil numberOfLoops:0 volume:0.4];
    
    if (APPDELEGATE.isAllowMusic) {
        [bgSoundplayer play];
    }
    
    
    
    if (APPDELEGATE.appVersionInfo) {
        
        [self setTotalAmount:APPDELEGATE.userGoldAmont];
        [super viewDidLoad];
        if (APPDELEGATE.appVersionInfo.isHide==1) {
            _exchangeButton.hidden=YES;
        }
    }else{
        [SVProgressHUD showWithStatus:@"数据加载中..."];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delayInitViewDidLoad) name:APPINFO_DID_LOADED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildScrollTextView) name:STRING_ARRAY_FOR_WALL_LOADED object:nil];
        
    }
    
    [_exchangeButton addTarget:self action:@selector(toExchangeMoney) forControlEvents:UIControlEventTouchUpInside];
    [_getGoldButton addTarget:self action:@selector(toGetGold) forControlEvents:UIControlEventTouchUpInside];
    
    //bannar广告
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (([AppUtilities isIOS6] || [AppUtilities isIOS5]) && [APP_NAME isEqualToString:APPNAME_ZuanZuanZuan] && APPDELEGATE.isChangeStatusBarY){
        [self.view setFrameOriginY:-20];
        [self.view setFrameSizeHeight:self.view.frame.size.height+20];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.qumiBannerAD removeFromSuperview];
    self.qumiBannerAD=nil;
    [bgSoundplayer stop];
    bgSoundplayer=nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark ---customer Actions
-(void) afterGoldReloaded
{
    [super afterGoldReloaded];
    [self setAwardGoldAmount:0];
    NSLog(@"%d",APPDELEGATE.userGoldAmont);
    [self setTotalAmount:APPDELEGATE.userGoldAmont];
}


-(void) delayInitViewDidLoad
{
    if (APPDELEGATE.appVersionInfo.isHide==1) {
        _exchangeButton.hidden=YES;
    }
    [SVProgressHUD dismiss];
    [self setTotalAmount:APPDELEGATE.userGoldAmont];
    [super viewDidLoad];
}

#pragma mark - Private Methods
-(void) buildScrollTextView
{
    if (APPDELEGATE.appVersionInfo && APPDELEGATE.appVersionInfo.isHide==0) {
        if (_scrollTextView) {
            [_scrollTextView removeFromSuperview];
        }
        NSArray *textArray=APPDELEGATE.exchangeArrayForWall;
        _scrollTextView =[self createBlackTextScrollViewWithFrame:CGRectMake(0, 0, 320, 20) withTextArray:textArray];
        _scrollTextView.tag=786;
        [self.view addSubview:_scrollTextView];
    }
}

-(void)setTotalAmount:(NSInteger)totalAmount
{
    _totalAmount=totalAmount;
    [_mainGoldLable setIntNumber:_totalAmount numberSize:6];;
}

-(void) setCoinAmount:(int)coinAmount
{
    _coinAmount=coinAmount;
    [_coinGoldLable setIntNumber:_coinAmount*oneCoinWorth numberSize:3];
}

-(AVAudioPlayer *) setAudioPlay:(AVAudioPlayer *) thePlayer WithSoundFileName:(NSString *) name offileType:(NSString *) type numberOfLoops:(int) numberOfLoops volume:(float) volume
{
    if (!type) {
        type=@"wav";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    //在这里判断以下是否能找到这个音乐文件
    if (path) {
        //从path路径中 加载播放器
        thePlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:path]error:nil];
        //初始化播放器
        [thePlayer prepareToPlay];
        
        //设置播放循环次数，如果numberOfLoops为负数 音频文件就会一直循环播放下去
        thePlayer.numberOfLoops = numberOfLoops;
        
        //设置音频音量 volume的取值范围在 0.0为最小 0.1为最大 可以根据自己的情况而设置
        thePlayer.volume = volume;
        
        NSLog(@"播放加载");
    }
    return thePlayer;
}

- (void)start {
    if (_coinAmount==0) {
        [self showFUIAlertViewWithTitle:@"提示" message:@"请先投注!" withTag:-1 cancleButtonTitle:@"好的" otherButtonTitles: nil];
        return;
    }
    
    [AppUtilities showHUDWithStatus:@"预备..."];
    
    [TouziType buyTouziWithData:[AppUtilities goldDataEncryptWithPid:1 andGoldAmount:_coinAmount*oneCoinWorth] OnSuccess:^(id respons) {
        awardTimes = [[respons objectForKey:@"awardTimes"] integerValue];
        _awardGoldAmount= [[respons objectForKey:@"resultValue"] integerValue];
        int userGold = [[respons objectForKey:@"userGold"] integerValue];
        int number =[[respons objectForKey:@"number"] integerValue];
        int resultNumber1 =[[respons objectForKey:@"resultNumber1"] integerValue];
        int resultNumber2 =[[respons objectForKey:@"resultNumber2"] integerValue];
        int resultNumber3 =[[respons objectForKey:@"resultNumber3"] integerValue];
        NSLog(@"%d,%d,%d,%d,%d",number,awardTimes,resultNumber1,resultNumber2,resultNumber3);
        
        APPDELEGATE.userGoldAmont=userGold;
        if (awardTimes>1.0) {
            isBigWin=YES;
        }else if(awardTimes>0){
            isSmallWin=YES;
        }
        [_rollingBoxView startRollingWithNumberOne:resultNumber1 two:resultNumber2 three:resultNumber3];
        NSLog(@"%@",respons);
        [AppUtilities dismissHUD];
    } failure:^(id error) {
        [AppUtilities handleErrorMessage:error];
    }];
}


-(void) addCoin:(UIButton *) button
{
    if (_totalAmount<10) {
        [self showFUIAlertViewWithTitle:@"提示!" message:@"金币不足啦!快去赚取金币吧!" withTag:GET_GOLD_ALERT_TAG cancleButtonTitle:@"好的!" otherButtonTitles: nil];
        return;
    }
    int number=1;
    if ([button isEqual:_betTenutton]) {
        if (_totalAmount<100) {
            return;
        }
        number=10;
    }
    
    if ((_coinAmount+number)>99) {
        return;
    }
    
    if (APPDELEGATE.isAllowSound) {
        dropCpinSoundplayer.currentTime=0;
        [dropCpinSoundplayer play];
    }
    
    
    [self setCoinAmount:_coinAmount+number];
    [self setTotalAmount:_totalAmount-number*oneCoinWorth];
}



-(void) dropCoinWithAwardGoldWithCoinAmont:(int) coinAmount
{
    _dropCoinView =[[coinView alloc] initWithFrame:CGRectMake(0, 0, 320, 300) withNum:coinAmount];
    _dropCoinView.coindelegate=self;
    [self.view addSubview:_dropCoinView];
}

#pragma mark - rollingBoxViewDelegate

- (void)rollingViewWillStartRolling {
    _startButton.enabled = NO;
    _betOneButton.enabled=NO;
    _betTenutton.enabled=NO;
    if (APPDELEGATE.isAllowSound) {
        [beforeSpinSoundplayer play];
        [spinSoundplayer play];
        
    }
} 

-(void) rollingViewWillEndRolling
{
    _startButton.enabled = YES;
    _betOneButton.enabled=YES;
    _betTenutton.enabled=YES;
    // [spinSoundplayer stop];
    
    if (isBigWin) {
        if (APPDELEGATE.isAllowSound)
            [winThreeSoundplayer play];
        isBigWin=NO;
    }else if (isSmallWin){
        if (APPDELEGATE.isAllowSound)
            [winTwoSoundplayer play];
        isSmallWin=NO;
    }
    if (_awardGoldAmount>0) {
        [self dropCoinWithAwardGoldWithCoinAmont:_awardGoldAmount];
    }
    
    [self setTotalAmount:APPDELEGATE.userGoldAmont];
    [self setCoinAmount:0];
    awardTimes=0;
    if (APPDELEGATE.appVersionInfo.isHide==1)
        [self showBannerAd];
}

#pragma mark - coinViewdelegate

-(void)coinAnimationFinished
{
    [_dropCoinView removeFromSuperview];
    _dropCoinView = nil;
    _awardGoldAmount=0;
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    _startButton.highlighted = YES;
    [_startButton performSelector:@selector(setHighlighted:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.8];
    
    [self start];
}

#pragma mark -customSwitchButtonDelegate

-(void) didEndSwitchTap:(id)swithcButton WithState:(BOOL)on
{
    if (on) {
        if (swithcButton ==_musicSwitchButton) {
            if (![bgSoundplayer isPlaying]) {
                APPDELEGATE.isAllowMusic=YES;
                [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"isAllowMusic"];
                [bgSoundplayer play];
            }
        }else if (swithcButton == _soundSwitchButton){
            if (!APPDELEGATE.isAllowSound) {
                APPDELEGATE.isAllowSound=YES;
                [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"isAllowSound"];
            }
        }
    }else{
        if (swithcButton ==_musicSwitchButton) {
            if ([bgSoundplayer isPlaying]) {
                APPDELEGATE.isAllowMusic=NO;
                [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"isAllowMusic"];
                [bgSoundplayer stop];
            }
        }else if (swithcButton == _soundSwitchButton){
            if (APPDELEGATE.isAllowSound) {
                APPDELEGATE.isAllowSound=NO;
                [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"isAllowSound"];
                [winTwoSoundplayer stop];
                [winThreeSoundplayer stop];
                [spinSoundplayer stop];
                [beforeSpinSoundplayer stop];
                [exChangeSoundplayer stop];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (FBLCDFontView *)CreateLCDFontWithFrame:(CGRect ) frame withTxt:(NSString *) text
{
    FBLCDFontView *v = [[FBLCDFontView alloc] initWithFrame:frame];
    v.text = text;
    v.lineWidth = 3.0;
    v.drawOffLine = NO;
    v.edgeLength = 10;
    v.margin = 6;
    v.backgroundColor = [UIColor blackColor];
    v.horizontalPadding = 5;
    v.verticalPadding = 5;
    v.glowSize = 5.0;
    v.glowColor = UIColorFromRGB(0x00ffff);
    v.innerGlowColor =UIColorFromRGB(0x00ffff);
    v.innerGlowSize = 3.0;
    v.backgroundColor=[UIColor clearColor];
    [self.view addSubview:v];
    [v resetSize];
    return v;
}
- (FBGlowLabel *) CreateFBGlowLabelWithFrame:(CGRect ) frame withTxt:(NSString *) text withFontSize:(int) fontSize
{
    FBGlowLabel *v = [[FBGlowLabel alloc] initWithFrame:frame];
    v.text = text;
    v.textAlignment = NSTextAlignmentCenter;
    v.clipsToBounds = YES;
    v.backgroundColor = [UIColor clearColor];
    v.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
    v.alpha = 1.0;
    v.glowSize = 20;
    v.innerGlowSize = 4;
    v.textColor = UIColor.whiteColor;
    v.glowColor = UIColorFromRGB(0x00ffff);
    v.innerGlowColor = UIColorFromRGB(0x00ffff);
    [self.view addSubview:v];
    return v;
}


#pragma -mark Custom Actions
-(BOOL) checkBetCoin
{
    if (_coinAmount>0) {
        [self showFUIAlertViewWithTitle:@"提示" message:@"请您先完成这轮的游戏!" withTag:-1 cancleButtonTitle:@"好的" otherButtonTitles: nil];
        return NO;
    }
    return YES;
}

-(void) toGetGold
{
    if (![self checkBetCoin]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_VIEW_TO_IDENTIFIER object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"GetGoldViewController",@"identifier",nil]];
}
-(void) toExchangeMoney
{
    if (![self checkBetCoin]) {
        return;
    }
    [[NSNotificationCenter defaultCenter]  postNotificationName:CHANGE_VIEW_TO_IDENTIFIER object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"goldExchangeViewController",@"identifier",nil]];
}

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag==GET_GOLD_ALERT_TAG) {
        [self toGetGold];
    }
}




-(void) showBannerAd
{
    if(self.qumiBannerAD){
        [UIView animateWithDuration:1.0f animations:^{
            self.qumiBannerAD.center=CGPointMake(160, 25);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 delay:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.qumiBannerAD.center=CGPointMake(160, -25);
            } completion:^(BOOL finished) {
            }];
        }];
    }
}

@end
