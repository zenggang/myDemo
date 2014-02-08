#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "WapsUIWebPageView.h"
#import "AppConnect.h"


@class WapsUINavigationBarView;
@class WapsMenu;

@interface WapsOffersWebView : WapsUIWebPageView <SKStoreProductViewControllerDelegate> {
    WapsUINavigationBarView *navBar_;
    UIViewController *parentVController_;
    BOOL enableNavBar;
    BOOL enableAutoJudge;
    NSString *isSelectorVisible_;
    NSString *orientationType_;
    int primaryColorCode_;
    UIColor *userDefinedColor_;
    UIActivityIndicatorView *activityIndicator_;
    WapsRefreshTableHeaderView * _refreshHeaderView;
    BOOL _reloading;
    WapsMenu *_wapsMenu;
    NSMutableArray *_menuArray;

}

@property(nonatomic, assign) UIViewController *parentVController_;
@property(nonatomic, retain) NSString *isSelectorVisible_;
@property(nonatomic, retain) NSString *fontColor;
@property(nonatomic, retain) WapsUINavigationBarView *navBar;
@property(nonatomic, retain) UIActivityIndicatorView *activityIndicator_;
@property(nonatomic, retain) NSString *orientationType;
@property(nonatomic, retain) NSMutableArray *menuArray;
@property(nonatomic, retain) WapsMenu *wapsMenu;


- (id)initWithFrame:(CGRect)frame enableNavBar:(BOOL)enableNavigationBar autoJudge:(BOOL)judge;

- (void)initOfferWithFrame:(CGRect)frame enableNavBar:(BOOL)enableNavigationBar autoJudge:(BOOL)judge;

- (void)setCustomNavBarImage:(UIImage *)image;

- (void)loadViewWithURL:(NSString *)URLString;

- (NSString *)setUpOffersURLWithServiceURL:(NSString *)serviceURL;

- (void)refreshWebView;

- (void)showMenu;


@end