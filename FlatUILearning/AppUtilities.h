//
//  AppUtilities.h
//  golf
//
//  Created by Ljx 李洁信 on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define MESSAGE_COLOR_STRONG [UIColor colorWithRed:0.14f green:0.15f blue:0.17f alpha:1.00f]
#define MESSAGE_COLOR_AT [UIColor colorWithRed:0.07f green:0.47f blue:0.82f alpha:1.00f]
#define MESSAGE_COLOR_LINK [UIColor colorWithWhite:0.000 alpha:1.000]
#define MESSAGE_FONT_SIZE 14.0f
#define MESSAGE_COLOR_TEXT [UIColor colorWithWhite:0.396 alpha:1.000]
#define MESSAGE_COLOR_COVER [UIColor lightGrayColor]
#define MESSAGE_FONT_TEXT [UIFont fontWithName:@"Helvetica" size:14.0]

// #define MESSAGE_COLOR_AT [UIColor colorWithRed:0.14f green:0.15f blue:0.17f alpha:1.00f]

@interface AppUtilities : NSObject

+ (BOOL) onnectedToNetwork;
- (BOOL) detectNeedUpdateWithNewVersion:(NSString *)newVer;
+ (BOOL) isIOS5;
+ (BOOL) isIOS6;
+ (BOOL) isIOS7;

+ (NSString *) deviceToken;
+(NSString *) HomeFilePath;
// HUD helpers
+ (void) showHUDWithStatusMaskTypeClear:(NSString *)status;
+ (void) showHUDWithStatus:(NSString *)status;
+ (void) showHUDWithStatusForAWhile:(NSString *)status;
+ (void) dismissHUD;
+ (void) dismissHUDWithSuccessForAWhile:(NSString *)status;
+ (void) dismissHUDWithErrorForAWhile:(NSString *)error;

// Time
+ (NSString *) dateFromString:(NSString *)str;
+ (NSString *) dateFromNSDate:(NSDate *)date;
+(NSString *) DateStringFromDateTime:(NSDate *)date;
+ (NSDate *) convertStringToDate:(NSString *)dateString withFormat:(NSString *)fmt withLocalize:(BOOL)isLocalize;
+ (NSString *) convertDateToString:(NSDate *)date withFormat:(NSString *)fmt withLocalize:(BOOL)isLocalize;

// UI Helpers
+ (UIButton *)getButtonWithText:(NSString *)text x:(float)x y:(float)y color:(UIColor *)color font:(UIFont *)font target:(id)target selector:(SEL)selector tag:(int)tag;
+(CGRect) changeViewFrameJustForHight:(float) height withView:(UIView *) view;
+(CGRect) changeViewFrameJustForY:(float) y withView:(UIView *) view;
// UI Cells
+ (void)setTransparentBackgroundForCell:(UITableViewCell *)cell;

// File management
+ (NSString *)documentsDirectoryPath;
+ (void)removeFileAtPath:(NSString *)path;

// UIView screenshot
+ (UIImage *)imageByScreenshotView:(UIView *)theView;
// Save to Album
+ (void)saveImageToAlbum:(UIImage *)image;

// Image File Name Generators

#define BUCKET_NAME @"gw-golf"
#define PORTRAIT_FOLDER @"portrait"
#define HOME_PIC_FOLDER @"homepic"
#define STATUS_FOLDER @"status"
#define SCANCARD_FOLDER @"scancard"
#define FOURM_FOLDER @"fourm"

+ (NSString *)getThumbnailFileNameFromName:(NSString *)name;
+ (NSString *)getS3PublicImagePathWithFileName:(NSString *)name;
+ (NSString *)getRandomImageFileNameWithFolder:(NSString *)folder memberID:(int)memberId;
+ (NSString *)getRandomImageFileNameWithFolder:(NSString *)folder memberID:(int)memberId uniqueId:(int)seq;
    
// Version

+ (BOOL)detectIfAppShouldUpdatedToNewVersion:(NSString *)newVer;

// UIImage
+ (UIImage *)rotateImage:(UIImage *)aImage;
    
//UIView
+ (id)loadViewFromNibNamed:(NSString*)nibName;
 

    
//Comment At parser
+ (NSString *)atStringFromText:(NSString *)text;

+ (NSString *)htmlStringFromTextByConvertingAtToLinks:(NSString *)text;

//Convert NSdata to base64
//from ASIHTTPRequest
+ (NSString *)base64forData:(NSData *)theData;

//Notifications
+ (void)cleanNotificationCenter;
//GOLD
+(NSString *) goldDataEncryptWithPid:(int) pid andGoldAmount:(int) goldAmount;
+(void) handleErrorMessage:(id )error;
+(NSString *) TheSecretForAddGold:(int) addGold WithTotalGold:(int) totalGold withPid:(int) pid;
+(NSString *) TheSecretForExchangeGold:(NSString *) exchangeData;
+(UIImage *) getImageFromUIView:(UIView *) view;
@end