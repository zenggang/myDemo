//
//  BaseViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-3.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];

    if ([AppUtilities isIOS7]) {
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont: [UIFont boldFlatFontOfSize:18],UITextAttributeTextColor:[UIColor whiteColor]};
        [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    }else{
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont: [UIFont boldFlatFontOfSize:18],UITextAttributeTextColor:[UIColor whiteColor]};
        [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    }
    if ([AppUtilities isIOS7]) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
}

#pragma mark -
#pragma mark Custom creation metod
-(void) createNavigationRightButtonWithTitle:(NSString *) title action:(SEL) action
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:action];
    if (![AppUtilities isIOS7]) {
        [UIBarButtonItem configureFlatButtonsWithColor:[UIColor peterRiverColor]
                                      highlightedColor:[UIColor belizeHoleColor]
                                          cornerRadius:3
                                       whenContainedIn:[UINavigationBar class], nil];
    
        [self.navigationItem.rightBarButtonItem removeTitleShadow];
    }
}

-(void) createNavigationLeftButtonWithTitle:(NSString *) title action:(SEL) action
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:action];
    if (![AppUtilities isIOS7]) {
        [UIBarButtonItem configureFlatButtonsWithColor:[UIColor peterRiverColor]
                                      highlightedColor:[UIColor belizeHoleColor]
                                          cornerRadius:3
                                       whenContainedIn:[UINavigationBar class], nil];
         

        [self.navigationItem.leftBarButtonItem removeTitleShadow];
    }
}

-(FUIButton *) createFUIButtonWithFrame:(CGRect)frame cornerRadius:(float) cornerRadius clickAction:(SEL) action fontSize:(UIFont *) font buttonColor:(UIColor *)buttonColor shadowColor:(UIColor *)shadowColor titleColor:(UIColor *) titleColor withText:(NSString *) text
{
    FUIButton *myButton= [[FUIButton alloc] initWithFrame:frame];
    if (!buttonColor) {
        buttonColor= GREEN_COLOR;
    }
    if (!shadowColor) {
        shadowColor=APPDELEGATE.sysButtonShadowColor;
    }
    if (!titleColor) {
        titleColor=[UIColor cloudsColor];
    }
    myButton.buttonColor =buttonColor;
    myButton.shadowColor = shadowColor;
    myButton.shadowHeight = 2.0f;
    myButton.cornerRadius =cornerRadius;
    myButton.titleLabel.font = font;
    [myButton setTitle:text forState:UIControlStateNormal];
    [myButton setTitleColor:titleColor forState:UIControlStateNormal];
    [myButton setTitleColor:titleColor forState:UIControlStateHighlighted];
    [myButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return myButton;
}


-(FUIAlertView *) CreateFUIAlertViewWithTitle:(NSString *) title message:(NSString *) message withTag:(int) tag  cancleButtonTitle:(NSString *) cancleTitle otherButtonTitles:(NSString *)otherButtonTitles,...
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
        [alertView addButtonWithTitle:arg];
    }
    va_end(args);
    [alertView addButtonWithTitle:cancleTitle];
    
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = GREEN_COLOR;
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    if(tag!=-1)
        alertView.tag=tag;
    return alertView;
}

-(void) showFUIAlertViewWithTitle:(NSString *) title message:(NSString *) message withTag:(int) tag  cancleButtonTitle:(NSString *) cancleTitle otherButtonTitles:(NSString *)otherButtonTitles,...
{

    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
        [alertView addButtonWithTitle:arg];
    }
    va_end(args);
    [alertView addButtonWithTitle:cancleTitle];
    
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = GREEN_COLOR;
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    if(tag!=-1)
        alertView.tag=tag;
    [alertView show]; 
}

-(UIView *) loadViewFromXibName:(NSString *) nibName
{
    NSArray *objectsInNib = [[NSBundle mainBundle] loadNibNamed:nibName
                                                          owner:self
                                                        options:nil];
    return (UIView *)objectsInNib[0];
}

-(DMScrollingTicker *) createTextScrollViewWithFrame:(CGRect) frame withTextArray:(NSArray *) textArray
{
    DMScrollingTicker *scrollingTicker = [[DMScrollingTicker alloc] initWithFrame:frame];

    scrollingTicker.backgroundColor = [UIColor sunflowerColor];
    //[self.view addSubview:scrollingTicker];
    NSMutableArray *l = [[NSMutableArray alloc] init];
    NSMutableArray *sizes = [[NSMutableArray alloc] init];
    for (NSString *text in textArray) {
        LPScrollingTickerLabelItem *label = [[LPScrollingTickerLabelItem alloc] initWithTitle:[NSString stringWithFormat:@""]
                                                                                  description:text];
        label.descriptionLabel.textColor=[UIColor midnightBlueColor];
        label.descriptionLabel.font=[UIFont flatFontOfSize:14];
        [label layoutSubviews];
        [sizes addObject:[NSValue valueWithCGSize:label.frame.size]];
        [l addObject:label];
    }
    
    [scrollingTicker beginAnimationWithViews:l
                                   direction:LPScrollingDirection_FromRight
                                       speed:40
                                       loops:40
                                completition:^(NSUInteger loopsDone, BOOL isFinished) {
                                    //NSLog(@"loop %d, finished? %d",loopsDone,isFinished);
                                }];
    return scrollingTicker;
}


#pragma mark -
#pragma mark Custom action metod

-(void) showMenuLeft
{
    [self.slidingViewController anchorTopViewTo:ECRight];

}

-(void) showMenuRight
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}


-(void) addOperationQueue:(SEL) action withObject:(id) object
{
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self
                                        selector:action
                                        object:object];
    [queue addOperation:operation];
}

-(McDownload *) downloadFileWithUrl:(NSString *) url fileName:(NSString *) fileName withDelegete:(id) delegate
{
    
    McDownload *downloader = [[McDownload alloc] init];
    downloader.delegate = delegate;
    NSURL *downloadUrl = [NSURL URLWithString:url];
    downloader.url = downloadUrl;
    downloader.filePath=[AppUtilities HomeFilePath];
    downloader.fileName = fileName;
    [downloader start];
    return downloader;
}

#pragma mark -
#pragma mark System

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait); 
}


@end
