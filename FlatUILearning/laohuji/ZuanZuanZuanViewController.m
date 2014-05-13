
#import "ZuanZuanZuanViewController.h"
#import "FBLCDFontView+Extend.h"
#import "TheLightsView.h"
#import "FBGlowLabel.h"
#import "LaohuJiType.h"
#import "AppUtilities.h"


@interface ZuanZuanZuanViewController()

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
//@property (nonatomic,weak) IBOutlet ScorllNumberLable *awardGoldLable;


@property (nonatomic,strong) UIImageView *backgroudImageView;
@property (nonatomic,strong) UIImageView *topView;
@property (nonatomic,strong) UIImageView *topBgView;

@property (nonatomic,assign) int coinAmount;
@property (nonatomic,assign) NSInteger totalAmount;
@property (nonatomic,assign) int awardGoldAmount;
@property (nonatomic,strong) coinView *dropCoinView;

@property (nonatomic,strong)  customSwitchButton *musicSwitchButton;
@property (nonatomic,strong)  customSwitchButton *soundSwitchButton;
@property (nonatomic,weak) IBOutlet UIImageView *musicText;
@property (nonatomic,weak) IBOutlet UIImageView *soundText;

@property (nonatomic,strong) UIImageView *topRuleFruits;
@property (nonatomic,strong) UIImageView *topRuleSeven;


@property (nonatomic,strong) TheLightsView *theLightView;

@property (nonatomic, strong) immobView *adView_Banner;

-(void) toExchangeMoney;
-(void) toGetGold;
-(void) showBannerAd;
@end
#define GET_GOLD_ALERT_TAG 4563

@implementation ZuanZuanZuanViewController {
 @private
    ZCSlotMachine *_slotMachine;
    
    
    
    NSArray *_slotIcons;
    
    int startTime;
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
    double awardTimes;
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
    [_theLightView stopLightingAnimation];
    _theLightView=nil;
}


- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    isHideStatusBar=YES;
	oneCoinWorth=10;
    self.wantsFullScreenLayout = YES;
    
    //顶部背景
    _topBgView=[[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 320, 132)];
    _topBgView.image=[UIImage imageNamed:@"top_bg"];
    [self.view addSubview:_topBgView];
//    _topView =[[UIImageView alloc ] initWithFrame:CGRectMake(0,0, 320, 115)];
//    _topView.image=[UIImage imageNamed:@"top"];
//    [self.view addSubview:_topView];
    _theLightView =[[TheLightsView alloc] initWithFrame:CGRectMake(6, 4, 320, 115) withRow:7 withColumn:26];
    [self.view addSubview:_theLightView];
    
    _topRuleFruits =[[UIImageView alloc] initWithFrame:CGRectMake(50, 25, 75, 50)];
    _topRuleFruits.image=[UIImage imageNamed:@"top_rule_fruits"];
    _topRuleSeven =[[UIImageView alloc] initWithFrame:CGRectMake(170, 25, 75, 50)];
    _topRuleSeven.image=[UIImage imageNamed:@"top_rule_7"];
    [self.view addSubview:_topRuleSeven];
    [self.view addSubview:_topRuleFruits];
    
    [LaohuJiType getLahujiListOnSuccess:^(id list) {
        NSMutableArray *typeList=list;
        for (LaohuJiType *type in typeList) {
            if ([type.type isEqualToString:@"f"]) {
                if (type.count==4) {
                    [self CreateFBGlowLabelWithFrame:CGRectMake(124, 25, 35, 16) withTxt:[NSString stringWithFormat:@"%d",type.awardTimes] withFontSize:15];
                }else if (type.count==3) {
                    [self CreateFBGlowLabelWithFrame:CGRectMake(124, 42, 35, 16) withTxt:[NSString stringWithFormat:@"%d",type.awardTimes] withFontSize:15];
                }else if (type.count==2) {
                    [self CreateFBGlowLabelWithFrame:CGRectMake(124, 60, 35, 16) withTxt:[NSString stringWithFormat:@"%d",type.awardTimes] withFontSize:15];
                }
            }else if ([type.type isEqualToString:@"s"]) {
                if (type.count==4) {
                    [self CreateFBGlowLabelWithFrame:CGRectMake(245, 25, 35, 16) withTxt:[NSString stringWithFormat:@"%d",type.awardTimes] withFontSize:15];
                }else if (type.count==3) {
                    [self CreateFBGlowLabelWithFrame:CGRectMake(245, 42, 35, 16) withTxt:[NSString stringWithFormat:@"%d",type.awardTimes] withFontSize:15];
                }else if (type.count==2) {
                    [self CreateFBGlowLabelWithFrame:CGRectMake(245, 60, 35, 16) withTxt:[NSString stringWithFormat:@"%d",type.awardTimes] withFontSize:15];
                }
            }
        }
        
    } failure:^(id error) {
    }];
    
    //滚动view
    if (IS_IPHONE5) {
        _slotMachine = [[ZCSlotMachine alloc] initWithFrame:CGRectMake(0, 0, 295, 221)];
        _slotMachine.center = CGPointMake(self.view.frame.size.width / 2, 247);
        _slotMachine.backgroundImage = [UIImage imageNamed:@"track"];
        _slotMachine.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        [_slotMachine setCoverImage:[UIImage imageNamed:@"track_mask"]];
    }else{
        _slotMachine = [[ZCSlotMachine alloc] initWithFrame:CGRectMake(0, 0, 295, 175)];
        _slotMachine.center = CGPointMake(self.view.frame.size.width / 2, 206);
        _slotMachine.backgroundImage = [UIImage imageNamed:@"track_small"];
        _slotMachine.contentInset = UIEdgeInsetsMake(13, 0, 13, 0);
        [_slotMachine setCoverImage:[UIImage imageNamed:@"track_small_mask"]];
    }
    _slotMachine.iconContentScale=2;
    _slotMachine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin; 
    _slotMachine.singleUnitDuration=0.14;
    _slotMachine.delegate = self;
    _slotMachine.dataSource = self;
    
    [self.view addSubview:_slotMachine];
    
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
        [_topBgView setFrameSizeHeight:122];
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
    [_topBgView setFrameOriginY:-1];
    if (([AppUtilities isIOS6] || [AppUtilities isIOS5]) && [APP_NAME isEqualToString:APPNAME_ZuanZuanZuan] && APPDELEGATE.isChangeStatusBarY){
        [self.view setFrameOriginY:-20];
        [self.view setFrameSizeHeight:self.view.frame.size.height+20];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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
    [LaohuJiType buyLaoHujiWithData:[AppUtilities goldDataEncryptWithPid:[_slotIcons count] andGoldAmount:_coinAmount*oneCoinWorth] OnSuccess:^(id respons) {
        awardTimes = [[respons objectForKey:@"awardTimes"] doubleValue];
        //int lid = [[respons objectForKey:@"lid"] integerValue];
        _awardGoldAmount= [[respons objectForKey:@"resultValue"] integerValue];
        int slotFourIndex = [[respons objectForKey:@"slotFourIndex"] integerValue];
        int slotOneIndex = [[respons objectForKey:@"slotOneIndex"] integerValue];
        int slotThreeIndex = [[respons objectForKey:@"slotThreeIndex"] integerValue];
        int slotTwoIndex = [[respons objectForKey:@"slotTwoIndex"] integerValue];
        int userGold = [[respons objectForKey:@"userGold"] integerValue];
        NSLog(@"%d,%d,%d,%d",slotOneIndex,slotTwoIndex,slotThreeIndex,slotFourIndex);
        _slotMachine.slotResults = [NSArray arrayWithObjects:
                                    [NSNumber numberWithInteger:slotOneIndex],
                                    [NSNumber numberWithInteger:slotTwoIndex],
                                    [NSNumber numberWithInteger:slotThreeIndex],
                                    [NSNumber numberWithInteger:slotFourIndex],
                                    nil];
        APPDELEGATE.userGoldAmont=userGold;
        if (awardTimes>2.0) {
            isBigWin=YES;
        }else if(awardTimes>0){
            isSmallWin=YES;
        }
        [_slotMachine startSliding];
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

#pragma mark - ZCSlotMachineDelegate

- (void)slotMachineWillStartSliding:(ZCSlotMachine *)slotMachine {
    _startButton.enabled = NO;
    _betOneButton.enabled=NO;
    _betTenutton.enabled=NO;
    startTime=[[NSDate date] timeIntervalSince1970];
    if (APPDELEGATE.isAllowSound) {
        [beforeSpinSoundplayer play];
        [spinSoundplayer play];
        
    }
}

- (void)slotMachineDidEndSliding:(ZCSlotMachine *)slotMachine {
    _startButton.enabled = YES;
    _betOneButton.enabled=YES;
    _betTenutton.enabled=YES;
    NSLog(@"%f",[[NSDate date] timeIntervalSince1970]-startTime);
    
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

#pragma mark - ZCSlotMachineDataSource

- (NSArray *)iconsForSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return _slotIcons;
}

- (NSUInteger)numberOfSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 4;
}

- (CGFloat)slotWidthInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 65.0f;
}

- (CGFloat)slotSpacingInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 5.0f;
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
