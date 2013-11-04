//
//  AppUtilities.m
//  golf
//
//  Created by Ljx 李洁信 on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppUtilities.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "SVProgressHUD.h"
#import "NSString+SSToolkitAdditions.h"

@implementation AppUtilities

+ (BOOL) onnectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
    
}

- (BOOL)detectNeedUpdateWithNewVersion:(NSString *)newVer {
    if (!newVer) {
        return NO;
    }
    
    NSString *curVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSArray *curVerTokens = [curVer componentsSeparatedByString:@"."];
    NSArray *newVerTokens = [newVer componentsSeparatedByString:@"."];
    
    for (int i=0; i<newVerTokens.count; i++) {
        NSString *newToken = [newVerTokens objectAtIndex:i];
        if (i >= curVerTokens.count) { //如果新版本长度>当前版本
            return YES;
        } else {
            NSString *curToken = [curVerTokens objectAtIndex:i];
            if ([newToken intValue] == [curToken intValue]) { //如果子版本相同, 继续比较下一个子版本
                continue;
            } else {
                return [newToken intValue] > [curToken intValue];
            }
        }
    }
    return NO;
}

+ (BOOL) isIOS5 {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 6.0);
}
+ (BOOL) isIOS6 {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 && [[[UIDevice currentDevice] systemVersion] floatValue]< 7.0);
}
+ (BOOL) isIOS7 {  
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue]< 8.0);
}

+ (NSString *) deviceToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    return token ? token : @"";        
}

+(NSString *) HomeFilePath
{
 //   NSString *strDic;
//    if ( [AppUtilities isIOS5]) {
//        strDic = [NSString stringWithFormat:@"%@/Library/Caches/",
//                  NSHomeDirectory()];
//    } else {
//        strDic = [NSString stringWithFormat:@"%@/Library/%@/",
//                  NSHomeDirectory(),
//                  [[NSBundle mainBundle] bundleIdentifier]];
//    }
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];//获取document目录然后将文件名追加进去
//    NSString *tmpPath = NSTemporaryDirectory(); //获取tmp目录
//    NSLog(@"%@",tmpPath);
//    NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"test"];
//    BOOL isDir;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:myDirectory isDirectory:&isDir] && isDir) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:myDirectory withIntermediateDirectories:NO attributes:nil error:nil];
//    } 
    return documentsDirectory;
}
// HUD helpers

#define HUD_DISPLAY_DELAY 1.5f
#define HUD_SUCCESS_DELAY 1.0f
#define HUD_FAIL_DELAY 1.0f

+ (void) showHUDWithStatusMaskTypeClear:(NSString *)status {
    [SVProgressHUD showWithStatus:status maskType:SVProgressHUDMaskTypeClear];    
}
+ (void) showHUDWithStatus:(NSString *)status {
    [SVProgressHUD showWithStatus:status maskType:SVProgressHUDMaskTypeNone];
}

+ (void) showHUDWithStatusForAWhile:(NSString *)status {
    [SVProgressHUD showWithStatus:status maskType:SVProgressHUDMaskTypeNone];
    //[SVProgressHUD dismissWithSuccess:status afterDelay:HUD_DISPLAY_DELAY];
    [SVProgressHUD dismiss];
}

+ (void) dismissHUD {
    [SVProgressHUD dismiss];
}

+ (void) dismissHUDWithSuccessForAWhile:(NSString *)status {
    //[SVProgressHUD dismissWithSuccess:status afterDelay:HUD_SUCCESS_DELAY];
    [SVProgressHUD dismiss];
}

+ (void) dismissHUDWithErrorForAWhile:(NSString *)error {
    //[SVProgressHUD dismissWithError:error afterDelay:HUD_FAIL_DELAY];
    [SVProgressHUD dismiss];
}


#pragma mark - 
#pragma mark Time

+ (NSString *) dateFromNSDate:(NSDate *)date {
    return [date descriptionWithLocale:[NSLocale systemLocale]];
}

+ (NSString *) dateFromString:(NSString *)str {
    static NSDateFormatter *fmtter;
    static NSString *fmt = @"yyyy-MM-dd HH:mm:ss Z";
    // [str stringByAppendingString:@" +0000"];
    if (fmtter == nil) {
        fmtter = [[NSDateFormatter alloc] init];
    }
    [fmtter setDateFormat:fmt];
    NSDate *date =[fmtter dateFromString:str];
    return [AppUtilities DateStringFromDateTime:date];
}

+(NSString *) DateStringFromDateTime:(NSDate *)date
{
    NSTimeInterval t =[date timeIntervalSinceNow];
    int time = [[NSNumber numberWithDouble:t] intValue]*-1;
    
    if (time<0) {
        time=1;
    }
    //gghhhhh
    if (time<2) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d秒前", nil),time==0 ? 1:time];
    } else if (time<60) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d秒前", nil),time==0 ? 1:time];
    } else if (time < 60*1.8){
        time = [[NSNumber numberWithDouble:time*0.01666666667 ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", nil),time==0 ? 1:time];
    } else if (time < 3600){
        time = [[NSNumber numberWithDouble:round(time*0.01666666667) ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", nil),time==0 ? 1:time];
    } else if (time < 3600*1.8){
        time = [[NSNumber numberWithDouble:time*0.0002777777778 ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d小时前", nil),time==0 ? 1:time];
    } else if (time<86400){
        time = [[NSNumber numberWithDouble:round(time*0.0002777777778) ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d小时前", nil),time==0 ? 1:time];
    } else if (time<86400*1.8){
        time = [[NSNumber numberWithDouble:time*0.000011574074074 ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d天前", nil),time==0 ? 1:time];
    } else if (time<2592000){
        time = [[NSNumber numberWithDouble:time*0.000011574074074 ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d天前", nil),time==0 ? 1:time];
    } else if (time<2592000*1.8){
        time = [[NSNumber numberWithDouble:time*0.0000003858 ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d月前", nil),time==0 ? 1:time];
    } else {
        time = [[NSNumber numberWithDouble:round(time*0.0000003858) ] intValue];
        return [NSString stringWithFormat:NSLocalizedString(@"%d月前", nil),time==0 ? 1:time];
    }
}

//NSString to NSDate
+ (NSDate *) convertStringToDate:(NSString *)dateString withFormat:(NSString *)fmt withLocalize:(BOOL)isLocalize
{
    NSString *formatString = fmt;
    if (isLocalize) {
        formatString = [NSDateFormatter dateFormatFromTemplate:formatString options:0 locale:[NSLocale systemLocale]];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}

//NSDate to NSString
+ (NSString *) convertDateToString:(NSDate *)date withFormat:(NSString *)fmt withLocalize:(BOOL)isLocalize
{
    NSString *formatString = fmt;
    if (isLocalize) {
        formatString = [NSDateFormatter dateFormatFromTemplate:formatString options:0 locale:[NSLocale systemLocale]];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}


#pragma mark - 
#pragma mark UI Helpers

+ (UIButton *)getButtonWithText:(NSString *)text x:(float)x y:(float)y color:(UIColor *)color font:(UIFont *)font target:(id)target selector:(SEL)selector tag:(int)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    CGSize size = [text sizeWithFont:button.titleLabel.font];
    button.frame = CGRectMake(x, y, size.width, size.height);
    return button;
}

+(CGRect) changeViewFrameJustForHight:(float) height withView:(UIView *) view
{
    return CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height);
}
+(CGRect) changeViewFrameJustForY:(float) y withView:(UIView *) view
{
    return CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height);
}

#pragma mark - 
#pragma mark UI Cells

+ (void)setTransparentBackgroundForCell:(UITableViewCell *)cell {

    UIImage* img = [UIImage imageNamed:@"zambie_photo.png"];
    UIImageView* imgV = [[UIImageView alloc] initWithImage:img];
    cell.backgroundView = imgV;
    
}


#pragma mark - 
#pragma mark File management

+ (NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    return documentsDirectoryPath;
}  

+ (void)removeFileAtPath:(NSString *)path {
    
    NSError *error = NULL;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// Check if the path exists, otherwise create it
	if ([fileManager fileExistsAtPath:path]) {
		[fileManager removeItemAtPath:path error:&error];
    }
    
}

#pragma mark -
#pragma mark UIImage screenshot

//截取
+ (UIImage *)imageByScreenshotView:(UIView *)theView {
    
    CGRect rect = theView.bounds;
    
    theView.backgroundColor=[UIColor clearColor];
    
    //支持retina
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(rect.size);
    }
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    [theView.layer renderInContext:currentContext];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (void)saveImageToAlbum:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}


#pragma mark - 
#pragma mark Thumbnail file name

+ (NSString *)getThumbnailFileNameFromName:(NSString *)name {
    if (name.length > 4) {
        return [name stringByReplacingCharactersInRange:NSMakeRange(name.length-4, 4) withString:@"mini.jpg"];
    } else {
        return name;
    }
}

+ (NSString *)getS3PublicImagePathWithFileName:(NSString *)name {
    return [NSString stringWithFormat:@"http://%@.s3.amazonaws.com/%@", BUCKET_NAME, name];
}

+ (NSString *)getRandomImageFileNameWithFolder:(NSString *)folder memberID:(int)memberId {
    return [AppUtilities getRandomImageFileNameWithFolder:folder memberID:memberId uniqueId:0];
}

+ (NSString *)getRandomImageFileNameWithFolder:(NSString *)folder memberID:(int)memberId uniqueId:(int)seq {
    int t = (int)([[NSDate date] timeIntervalSince1970]);
    NSString *ret = nil;
    if ([folder isEqualToString:PORTRAIT_FOLDER]) {
        ret = [NSString stringWithFormat:@"%@/%d.jpg", folder, memberId];
    } else {
        ret = [NSString stringWithFormat:@"%@/%d_%d_%d.jpg", folder, memberId, t, seq];
    }
    return ret;
}

#pragma mark Versions

+ (BOOL)detectIfAppShouldUpdatedToNewVersion:(NSString *)newVer {
    if (!newVer) {
        return NO;
    }
    
    NSString *curVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSArray *curVerTokens = [curVer componentsSeparatedByString:@"."];
    NSArray *newVerTokens = [newVer componentsSeparatedByString:@"."];
    
    for (int i=0; i<newVerTokens.count; i++) {
        NSString *newToken = [newVerTokens objectAtIndex:i];
        if (i >= curVerTokens.count) { //如果新版本长度>当前版本
            return YES;
        } else {
            NSString *curToken = [curVerTokens objectAtIndex:i];
            if ([newToken intValue] == [curToken intValue]) { //如果子版本相同, 继续比较下一个子版本
                continue;
            } else {
                return [newToken intValue] > [curToken intValue];
            }
        }
    }
    return NO;
}

#pragma mark -
#pragma mark UIImage 修正image方向

+ (UIImage *)rotateImage:(UIImage *)aImage {
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

#pragma mark -
#pragma mark UIView 

//Load view from nib file
+(id)loadViewFromNibNamed:(NSString*)nibName {
    NSArray *objectsInNib = [[NSBundle mainBundle] loadNibNamed:nibName
                                                          owner:self
                                                        options:nil];
    assert( objectsInNib.count == 1);
    return [objectsInNib objectAtIndex:0];
}


#pragma mark -
#pragma mark OHAttributedLabel Assistant


#pragma mark -
#pragma mark At parser

+ (NSString *)atStringFromText:(NSString *)text {
    
    // The NSRegularExpression class is currently only available in the Foundation framework of iOS 4
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
    
    NSMutableArray *atList = [[NSMutableArray alloc] initWithCapacity:2];
    
    [regex enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        //
        if (result.range.length > 2) {
            NSString *at = [[text substringWithRange:result.range] substringFromIndex:1];
            [atList addObject:at];
        }
    }];
    
    NSString *atString = [atList componentsJoinedByString:@","];
    
    return atString;
}

#pragma mark -
#pragma mark HTML tag for @xxx names

+ (NSString *)htmlStringFromTextByConvertingAtToLinks:(NSString *)text {
    
    if (!text) {
        return @"";
    }
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(@\\w+)" options:0 error:&error];
    
    NSMutableString *html = [NSMutableString stringWithString:text];
    [regex replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<b><a>$1</a></b>"];
    

    //LOG_EXPR(html);
    NSRegularExpression *urlRegex = [NSRegularExpression regularExpressionWithPattern:@"((http://)|(https://))?(www\\.)?[a-zA-Z0-9-]+\\.[a-zA-Z0-9%.-?=/]+" options:0 error:&error];
    [urlRegex replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<i><a href='$0'>$0</a></i>"];
    
//    //LOG_EXPR(html);
    return html;
}

#pragma mark -
#pragma mark Get base64 NSString from NSDate

+ (NSString *)base64forData:(NSData *)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
}

#pragma mark -
#pragma mark Notifications

+ (void)cleanNotificationCenter {
    //Clean notifications in Notification Center
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark -
#pragma mark GOLD
+(NSString *) goldDataEncryptWithPid:(int) pid andGoldAmount:(int) goldAmount
{
    NSString *pidString=[NSString stringWithFormat:@".%d",100-pid];
    NSString *goldstep1=[NSString stringWithFormat:@"%f",goldAmount*3.14159];
    NSString *goldChange2 =[NSString stringWithFormat:@".%d",goldAmount*36];
    NSArray *goldStep2 = [goldstep1 componentsSeparatedByString:@"."];
    NSString *result=[NSString stringWithFormat:@"%@%@.%@%@",goldStep2[1],goldChange2,goldStep2[0],pidString];
    return result;
}


+(NSString *) TheSecretForAddGold:(int) addGold WithTotalGold:(int) totalGold withPid:(int) pid
{
    NSString *resultString = [NSString stringWithFormat:@"%d.%d.%d%@",addGold,totalGold,pid,PRIVATE_SECRET_KEY];
    return [resultString MD5Sum]; 
}

+(NSString *) TheSecretForExchangeGold:(NSString *) exchangeData
{
    NSString *resultString = [NSString stringWithFormat:@"%@%@",exchangeData,PRIVATE_SECRET_KEY];
    return [resultString MD5Sum];
}

+(void) handleErrorMessage:(id )error{
    if ([error isKindOfClass:[NSDictionary class]] && [error objectForKey:@"message" ])
        [SVProgressHUD showErrorWithStatus:[error objectForKey:@"message" ]];
}


+(UIImage *) getImageFromUIView:(UIView *) view
{
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    
    //获取图像
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

