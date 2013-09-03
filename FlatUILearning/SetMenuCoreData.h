//
//  SetMenu.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-19.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SetMenuCoreData : NSManagedObject

@property (nonatomic, retain) NSString * setTitle;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * saveMoney;
@property (nonatomic, retain) NSString * menusString;
@property (nonatomic, retain) NSNumber * setId;

+(void) saveSetMenuToDisc:(SetMenu *) menu;
-(void) deleteMenuWithSetTitle;
@end
