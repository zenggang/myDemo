
#import "ZuanZuanZuanViewController.h"
#import "UIView+Helpers.h"

#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@interface ZuanZuanZuanViewController () 

@property (nonatomic,weak) IBOutlet UIButton *dropCoinButton;
@property (nonatomic,weak) IBOutlet UIButton *dropMaxCoinButton;
@property (nonatomic,weak) IBOutlet UIButton *startButton;


@property (nonatomic,weak) IBOutlet ScorllNumberLable *mainGoldLable;
@property (nonatomic,weak) IBOutlet ScorllNumberLable *coinGoldLable;
@property (nonatomic,weak) IBOutlet ScorllNumberLable *awardGoldLable;


@property (nonatomic,assign) int coinAmount;
@property (nonatomic,assign) NSInteger totalAmount;
@property (nonatomic,assign) int awardGoldAmount;
@property (nonatomic,strong) coinView *dropCoinView;
@property (nonatomic,weak) IBOutlet UIView *buttomView;
@property (nonatomic,weak) IBOutlet UIButton *exchangeButton;
@property (nonatomic,weak) IBOutlet UIButton *getGoldButtonl;

-(IBAction) payOutAwardCoin:(id) sender;
-(IBAction)controllSound:(id)sender;
@end

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
    BOOL isThreeWin;
    BOOL isFourWin;
    BOOL isTwoWin;
    BOOL isAllowPlaySound;
    int oneCoinWorth;
    double awardTimes;
}

#pragma mark - View LifeCycle
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _slotIcons = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"Star"], [UIImage imageNamed:@"MushroomRed"], [UIImage imageNamed:@"MushroomBlue"],[UIImage imageNamed:@"MushroomLife"],[UIImage imageNamed:@"MushroomYellow"], [UIImage imageNamed:@"MushroomGreen"], nil];
    }
    isAllowPlaySound=YES;

    return self;
}


- (void)dealloc {
    [_startButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
}

- (void)viewDidLoad {
    
	oneCoinWorth=10;
    self.wantsFullScreenLayout = YES;
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    
    if (IS_IPHONE5) {
        _slotMachine = [[ZCSlotMachine alloc] initWithFrame:CGRectMake(0, 0, 310, 193)];
        _slotMachine.center = CGPointMake(self.view.frame.size.width / 2, 261);
        _slotMachine.iconContentScale=6;
    }else{
        _slotMachine = [[ZCSlotMachine alloc] initWithFrame:CGRectMake(0, 0, 310, 140)];
        _slotMachine.center = CGPointMake(self.view.frame.size.width / 2, 222);
        _slotMachine.iconContentScale=7;
        
    }
    
    _slotMachine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _slotMachine.contentInset = UIEdgeInsetsMake(5, 8, 5, 8);
    _slotMachine.backgroundImage = [UIImage imageNamed:@"track2"];
    _slotMachine.coverImage = [UIImage imageNamed:@"white"];
    _slotMachine.singleUnitDuration=0.14;
    _slotMachine.delegate = self;
    _slotMachine.dataSource = self;
    
    [self.view addSubview:_slotMachine];
    

    [_startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [_dropCoinButton addTarget:self action:@selector(addCoin:) forControlEvents:UIControlEventTouchUpInside];
    [_dropMaxCoinButton addTarget:self action:@selector(addCoin:) forControlEvents:UIControlEventTouchUpInside];
    
    beforeSpinSoundplayer=[self setAudioPlay:beforeSpinSoundplayer WithSoundFileName:@"beforeSping2" offileType:@"wav" numberOfLoops:0 volume:0.2];
    spinSoundplayer=[self setAudioPlay:spinSoundplayer WithSoundFileName:@"spinging" offileType:@"wav" numberOfLoops:0 volume:0.4];
    dropCpinSoundplayer=[self setAudioPlay:dropCpinSoundplayer WithSoundFileName:@"dropCoin1" offileType:@"wav" numberOfLoops:0 volume:0.4];
    winTwoSoundplayer=[self setAudioPlay:winTwoSoundplayer WithSoundFileName:@"winTwo" offileType:@"wav" numberOfLoops:0 volume:0.5];
    winThreeSoundplayer =[self setAudioPlay:winThreeSoundplayer WithSoundFileName:@"winThree" offileType:@"wav" numberOfLoops:0 volume:0.5];
    bgSoundplayer=[self setAudioPlay:bgSoundplayer WithSoundFileName:@"loopj" offileType:@"wav" numberOfLoops:-1 volume:0.2];
    exChangeSoundplayer=[self setAudioPlay:exChangeSoundplayer WithSoundFileName:@"exchange" offileType:nil numberOfLoops:0 volume:0.4];
    [_mainGoldLable setUpScrollViewWithNumberSize:5];
    [_coinGoldLable setUpScrollViewWithNumberSize:3];
    [_awardGoldLable setUpScrollViewWithNumberSize:4];
    [bgSoundplayer play];
    
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
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![AppUtilities isIOS7]) {
        [self.view setFrameOriginY:-20];
        [self.view setFrameSizeHeight:self.view.frame.size.height+20];
    }
}
#pragma mark ---customer Actions
-(void) afterGoldReloaded
{
    [super afterGoldReloaded];
    [self setAwardGoldAmount:0];
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
    [_mainGoldLable setNumber:_totalAmount withAnimationType:ZCWScrollNumAnimationTypeNormal animationTime:0.4];
}

-(void) setCoinAmount:(int)coinAmount
{
    _coinAmount=coinAmount;
    [_coinGoldLable setNumber:_coinAmount*oneCoinWorth withAnimationType:ZCWScrollNumAnimationTypeNormal animationTime:0.3];
}
-(void)setAwardGoldAmount:(int)awardGoldAmount
{
    _awardGoldAmount=awardGoldAmount;
    [_awardGoldLable setNumber:_awardGoldAmount withAnimationType:ZCWScrollNumAnimationTypeNormal animationTime:0.4];
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

-(IBAction)controllSound:(UIButton *)sender
{
    if (isAllowPlaySound) {
        isAllowPlaySound=NO;
        //[sender setTitle:@"音效:off" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"switch_close"] forState:UIControlStateNormal];
        [winTwoSoundplayer stop];
        [winThreeSoundplayer stop];
        [spinSoundplayer stop];
        [beforeSpinSoundplayer stop];
        [exChangeSoundplayer stop];
    }else{
        isAllowPlaySound=YES;
        [sender setImage:[UIImage imageNamed:@"switch_open"] forState:UIControlStateNormal];
    }
}

-(IBAction)controllBgSound:(UIButton *)sender
{
    if ([bgSoundplayer isPlaying]) {
        [bgSoundplayer stop];
        [sender setImage:[UIImage imageNamed:@"switch_close"] forState:UIControlStateNormal];
    }else{
        [bgSoundplayer play];
         [sender setImage:[UIImage imageNamed:@"switch_open"] forState:UIControlStateNormal];
    }
}
- (void)start {
    
    if (_coinAmount==0) {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先投注!" delegate:self cancelButtonTitle:@"好的!" otherButtonTitles: nil] ;
        [alertView show];
        return;
    }
    
    NSUInteger slotIconCount = [_slotIcons count];
    //abs 取绝对值  arc4random() 随机数发生器 
    NSUInteger slotOneIndex = abs(arc4random() % slotIconCount);
    NSUInteger slotTwoIndex = abs(arc4random() % slotIconCount);
    NSUInteger slotThreeIndex = abs(arc4random() % slotIconCount);
    NSUInteger slotFourIndex = abs(arc4random() % slotIconCount);
    

    if (slotOneIndex==slotTwoIndex && slotTwoIndex==slotThreeIndex && slotFourIndex==slotThreeIndex){
        
        int retryRate = abs(arc4random() % 6);
        if (retryRate==0) {
            isFourWin=YES;
            awardTimes=(slotThreeIndex==0 ? 50:30);
        }else{
            NSLog(@"old FourWin %d,%d,%d,%d",slotOneIndex,slotTwoIndex,slotThreeIndex,slotFourIndex);
            [self start];
            return;
        }
        

    }else if ((slotOneIndex==slotTwoIndex && slotTwoIndex==slotThreeIndex) ||(slotFourIndex==slotThreeIndex && slotTwoIndex==slotThreeIndex)) {
        
        int retryRate = abs(arc4random() %3);
        if (retryRate==0) {
            isThreeWin=YES;
            awardTimes=(slotThreeIndex==0 ? 15:10);
        }else{
            NSLog(@"old ThreeWin %d,%d,%d,%d",slotOneIndex,slotTwoIndex,slotThreeIndex,slotFourIndex);
            [self start];
            return;
        }
        
        
    }else if ((slotOneIndex==slotTwoIndex) || (slotThreeIndex==slotTwoIndex) ||(slotThreeIndex== slotFourIndex)){
        
        isTwoWin=YES;
        awardTimes=0.5;
        if (((slotOneIndex==slotTwoIndex) && slotOneIndex==0) || ((slotThreeIndex== slotFourIndex) &&slotThreeIndex==0) || ((slotThreeIndex==slotTwoIndex) && slotTwoIndex==0)) {
            awardTimes=2;
        }
        
        if ((slotOneIndex==slotTwoIndex) && (slotThreeIndex== slotFourIndex)) {
            awardTimes=awardTimes+0.5;
        }
        
    }
    
    NSLog(@"%d,%d,%d,%d",slotOneIndex,slotTwoIndex,slotThreeIndex,slotFourIndex);
    _slotMachine.slotResults = [NSArray arrayWithObjects:
                                [NSNumber numberWithInteger:slotOneIndex],
                                [NSNumber numberWithInteger:slotTwoIndex],
                                [NSNumber numberWithInteger:slotThreeIndex],
                                [NSNumber numberWithInteger:slotFourIndex],
                                nil];
    
    [_slotMachine startSliding];
}

-(void) addCoin:(UIButton *) button
{
    if (_totalAmount<10) {
        return;
    }
    int number=1;
    if ([button isEqual:_dropMaxCoinButton]) {
        if (_totalAmount<100) {
            return;
        }
        number=10;
    }
    
    if ((_coinAmount+number)>99) {
        return;
    }
    
    if (isAllowPlaySound) {
        dropCpinSoundplayer.currentTime=0;
        [dropCpinSoundplayer play];
    }
    
    
    [self setCoinAmount:_coinAmount+number];
    [self setTotalAmount:_totalAmount-number*oneCoinWorth]; 
}

-(IBAction) payOutAwardCoin:(id) sender
{

    if (_awardGoldAmount>0) {
        [self setTotalAmount:_totalAmount+_awardGoldAmount];
        [self setAwardGoldAmount:0];
        if (isAllowPlaySound) {
            [exChangeSoundplayer play];
        }
    
    }
    
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
    _dropCoinButton.enabled=NO;
    _dropMaxCoinButton.enabled=NO;
    startTime=[[NSDate date] timeIntervalSince1970];
    if (isAllowPlaySound) {
        [beforeSpinSoundplayer play];
        [spinSoundplayer play];
        
    }
}

- (void)slotMachineDidEndSliding:(ZCSlotMachine *)slotMachine {
    _startButton.enabled = YES;
    _dropCoinButton.enabled=YES;
    _dropMaxCoinButton.enabled=YES;
    NSLog(@"%f",[[NSDate date] timeIntervalSince1970]-startTime);
    
   // [spinSoundplayer stop];
    
    if (isThreeWin) {
        if (isAllowPlaySound)
            [winThreeSoundplayer play];
        isThreeWin=NO;
    }else if (isFourWin){
        if (isAllowPlaySound)
            [winThreeSoundplayer play];
        isFourWin=NO;
    }else if (isTwoWin){
        if (isAllowPlaySound)
            [winTwoSoundplayer play];
        isTwoWin=NO;
    }
    int award =[[NSNumber numberWithFloat:_coinAmount*oneCoinWorth*awardTimes] intValue];
    if (award>0) {
        [self dropCoinWithAwardGoldWithCoinAmont:award];
        [self setAwardGoldAmount:_awardGoldAmount+award];
    }
    
    [self setCoinAmount:0];
    awardTimes=0;
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




#pragma mark test
-(IBAction)test:(id)sender
{
    _totalAmount=500000;
    _coinAmount=900;
    
    NSUInteger slotIconCount = [_slotIcons count];
    
    int loseTime=0;
    int Start_4=0;
    int Start_3=0;
    int Start_2=0;
    int mogu_4=0;
    int mogu_3=0;
    int mogu_2=0;
    
    for (int i=1; i<1000000;i++) {
        
        //abs 取绝对值  arc4random() 随机数发生器
        NSUInteger slotOneIndex = abs(arc4random() % slotIconCount);
        NSUInteger slotTwoIndex = abs(arc4random() % slotIconCount);
        NSUInteger slotThreeIndex = abs(arc4random() % slotIconCount);
        NSUInteger slotFourIndex = abs(arc4random() % slotIconCount);
        

        
         if (slotOneIndex==slotTwoIndex && slotTwoIndex==slotThreeIndex && slotFourIndex==slotThreeIndex){
            isFourWin=YES;
            awardTimes=(slotThreeIndex==0 ? 50:30);
            
            if (slotThreeIndex==0) {
                Start_4++;
            }else
                mogu_4++;
            
         }else if ((slotOneIndex==slotTwoIndex && slotTwoIndex==slotThreeIndex) ||(slotFourIndex==slotThreeIndex && slotTwoIndex==slotThreeIndex)) {
             
             isThreeWin=YES;
             awardTimes=(slotThreeIndex==0 ? 15:10);
             if (slotThreeIndex==0) {
                 Start_3++;
             }else
                 mogu_3++;
              
         }else if ((slotOneIndex==slotTwoIndex) || (slotThreeIndex==slotTwoIndex) ||(slotThreeIndex== slotFourIndex)){
            isTwoWin=YES;
            awardTimes=0.5;
            if (((slotOneIndex==slotTwoIndex) && slotOneIndex==0) || ((slotThreeIndex== slotFourIndex) &&slotThreeIndex==0) || ((slotThreeIndex==slotTwoIndex) && slotTwoIndex==0)) {
                awardTimes=2;
                Start_2++;
            }else
                mogu_2++;
            
            if ((slotOneIndex==slotTwoIndex) && (slotThreeIndex== slotFourIndex)) {
                awardTimes=awardTimes+0.5;
                mogu_2++;
            }
            
        }else{
            loseTime++;
            awardTimes=0;
        }
        
        
        _totalAmount=_totalAmount+_coinAmount*awardTimes-_coinAmount;
        if (_totalAmount<_coinAmount) {
            NSLog(@"破产次数 %d",i+1);
            break;
        }
    }
    
    NSLog(@"Start_4 :%d, Start_3:%d, Start_2 %d",Start_4,Start_3,Start_2);
    NSLog(@"mogu_4: %d,mogu_3 :%d,mogu_2: %d",mogu_4,mogu_3,mogu_2);
    NSLog(@"totle:%d",_totalAmount); 
}

@end
