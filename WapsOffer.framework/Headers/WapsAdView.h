#import "WapsUIWebPageView.h"
#import <StoreKit/StoreKit.h>
#import "AppConnect.h"

@interface WapsAdView : WapsUIWebPageView <SKStoreProductViewControllerDelegate>
{
    UIViewController *_parentVController;
    NSString *isSelectorVisible_;
    NSString *_contentSizeStr;
    CGFloat _showX;
    CGFloat _showY;
}

@property(nonatomic, retain) UIViewController *parentVController;
@property(nonatomic, retain) NSString *isSelectorVisible_;
@property(nonatomic, retain) NSString *contentSizeStr;
@property(nonatomic, assign) CGFloat showX;
@property(nonatomic, assign) CGFloat showY;

- (id)initWithSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;
- (id)initWithFrame:(CGRect)frame adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;


- (void)loadViewWithURL:(NSString *)URLString;
@end
