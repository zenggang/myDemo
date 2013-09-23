//
//  SetMenu.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-21.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetMenu : NSObject
@property (nonatomic, strong) NSString * setTitle;
@property (nonatomic, strong) NSString * picUrl;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, strong) NSNumber * saveMoney;
@property (nonatomic, strong) NSString * menusString;
@property (nonatomic, strong) NSNumber * setId;
@property (nonatomic,strong) NSString  *tempPicUrl;

@property (nonatomic,assign) double progressValue;

-(SetMenu *) initWithAttributes:(NSDictionary *) attributes;
+(NSMutableArray *) convertCoreDateToModel:(NSArray *) coreDataArray;
-(BOOL) checkImageFileDownLoaded;
-(NSString *) getPicFileName;
-(NSString *) getPicFileLocation;
@end
 