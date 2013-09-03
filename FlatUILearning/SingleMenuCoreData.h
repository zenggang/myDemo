//
//  SingleMenu.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-19.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SingleMenuCoreData : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * price;
+(void) saveSingleMenuToDisc:(SingleMenu *) menu;
- (void) deleteMenuWithTitle;
@end
