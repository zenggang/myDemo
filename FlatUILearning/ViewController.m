//
//  ViewController.m
//  FlatUILearning
//
//  Created by gang zeng on 13-5-16.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "ViewController.h"
#import "MenuView.h"
#import "RestaurantMapViewController.h"

@interface ViewController ()
{
     
}

@property (nonatomic,strong) FUISwitch *sSwitch;
@property (nonatomic,strong) DMScrollingTicker *scrollTextView;
-(void) buildScrollTextView;
@end



@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.title = @"麦当劳优惠劵";
    _dataArray =APPDELEGATE.allMenuSet;
    self.view.backgroundColor = [UIColor cloudsColor];
    [self checkDownloadPicInfo];
    _carouseView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 35, 320, 360)];
    _carouseView.delegate=self;
    _carouseView.dataSource=self; 
    _carouseView.type = iCarouselTypeCoverFlow2;
    _carouseView.scrollSpeed=0.7f;
    _carouseView.bounceDistance=0.4f;
    _carouseView.decelerationRate=0.8f;
    //_carouseView.dataSource=

    [self.view addSubview:_carouseView];
    _carouseView.clipsToBounds=YES;
    
    [self createNavigationRightButtonWithTitle:@"附近" action:@selector(showMenuRight)];
    [self createNavigationLeftButtonWithTitle:@"赚金币"  action:@selector(showMenuLeft)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:NEW_MENU_UPDATE_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildScrollTextView) name:STRING_ARRAY_FOR_WALL_LOADED object:nil];
    
    [self buildScrollTextView];
    
}

-(void) buildScrollTextView
{
    if (APPDELEGATE.appVersionInfo && APPDELEGATE.appVersionInfo.isHide==0) {
        if (_scrollTextView) {
            [_scrollTextView removeFromSuperview];
        }
        NSArray *textArray=APPDELEGATE.exchangeArrayForWall;
        _scrollTextView =[self createTextScrollViewWithFrame:CGRectMake(0, 0, 320, 20) withTextArray:textArray];
        _scrollTextView.tag=555;
        [self.view addSubview:_scrollTextView];
    }

}


-(void)viewWillUnload{
    [super viewWillUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:NEW_MENU_UPDATE_SUCCESS];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:STRING_ARRAY_FOR_WALL_LOADED];
}

-(void) reloadData:(NSNotification *)notification
{
    _dataArray =APPDELEGATE.allMenuSet;
    [self checkDownloadPicInfo];
    [_carouseView reloadData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[RestaurantMapViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantMapViewController"];
    }
   // [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"count"]) {
//        //do something
//        [_carouseView insertItemAtIndex:_dataArray.count-1 animated:YES];
//    }
//}

#pragma mark -
#pragma mark customer method


#pragma mark FUIAlertViewDelegate

#pragma mark iCarousel 
-(NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _dataArray.count;
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    SetMenu *menu=[_dataArray objectAtIndex:index];
    if (!view) {
        view = [self loadViewFromXibName:@"MenuView"];
    }
    MenuView *menuView =(MenuView *)view;
    [menuView setUpViewWithSetMenu:menu];
    return menuView;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carouseView.itemWidth);
}


- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    return value;
}

-(void) checkDownloadPicInfo
{
    _unDownLoadPicArray = [NSMutableArray array];
    for (SetMenu *menu in APPDELEGATE.allMenuSet) {
        if (![menu checkImageFileDownLoaded]) {
            [_unDownLoadPicArray addObject:menu];
        }
    }
    int length =(_unDownLoadPicArray.count >3 ? 3 :_unDownLoadPicArray.count);

    for (int i=0; i<length; i++) {
        SetMenu *menu=[_unDownLoadPicArray objectAtIndex:0];
        [self downloadFileWithUrl:menu.picUrl fileName:[menu getPicFileName] withDelegete:self];
        [_unDownLoadPicArray removeObjectAtIndex:0];
    }
}

#pragma mark McDownloadDelegate

- (void)downloadProgressChange:(McDownload *)aDownload progress:(double)newProgress
{
    
    for (MenuView *menuView in [_carouseView visibleItemViews]) {
        if ([[menuView.setMenu getPicFileName] isEqualToString:aDownload.fileName]) {
            [menuView setProgressWithProgress:newProgress];
        }
    }
    
}
//下载开始(responseHeaders为服务器返回的下载文件的信息)
- (void)downloadBegin:(McDownload *)aDownload didReceiveResponseHeaders:(NSURLResponse *)responseHeaders
{
    ////log4Debug(@"%@ ------ %@",aDownload.fileName,responseHeaders);
}
//下载失败
- (void)downloadFaild:(McDownload *)aDownload didFailWithError:(NSError *)error
{
    [aDownload stopAndClear];
    //log4Error(error);
    [self downLoadPicInOneProcess];
}
//下载结束
- (void)downloadFinished:(McDownload *)aDownload
{
    [self downLoadPicInOneProcess];
}

-(void) downLoadPicInOneProcess
{
    if(_unDownLoadPicArray.count>0){
        SetMenu *menu =[_unDownLoadPicArray objectAtIndex:0];
        [self downloadFileWithUrl:menu.picUrl fileName:[menu getPicFileName] withDelegete:self];
        [_unDownLoadPicArray removeObjectAtIndex:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
