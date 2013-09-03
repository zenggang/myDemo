//
//  SetMenu.m
//  FlatUILearning
//
//  Created by gang zeng on 13-6-19.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "SetMenuCoreData.h"


@implementation SetMenuCoreData

@dynamic setTitle;
@dynamic  picUrl;
@dynamic price;
@dynamic saveMoney;
@dynamic menusString;
@dynamic setId;


//-(NSArray *) getAllMenus
//{
//    
//    NSArray *menus =[self.menusString componentsSeparatedByString:@","];
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:menus.count];
//    for (NSString *title in menus) {
//        SingleMenu *menu =[SingleMenu MR_findFirstByAttribute:@"title" withValue:title];
//        [array addObject:menu];
//    }
//    return array;
//}


+(void) saveSetMenuToDisc:(SetMenu *) menu
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    SetMenuCoreData *menuSet =[SetMenuCoreData MR_createInContext:localContext];
    menuSet.setTitle=menu.setTitle;
    menuSet.price=menu.price; 
    menuSet.picUrl=menu.picUrl;
    menuSet.setId=menu.setId;
    menuSet.saveMoney=menu.saveMoney;
    menuSet.menusString=menu.menusString;
    [localContext MR_saveToPersistentStoreAndWait];
}


- (void) deleteMenuWithSetTitle{
    // Get the local context
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    // Build the predicate to find the person sought
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"setTitle ==[c] %@ ",self.setTitle];
    SetMenuCoreData *menuSet = [SetMenuCoreData MR_findFirstWithPredicate:predicate inContext:localContext];
    // If a person was founded
    if (menuSet) {
        // Update its age
        [menuSet MR_deleteInContext:localContext];
        // Save the modification in the local context
        // With MagicalRecords 2.0.8 or newer you should use the MR_saveNestedContexts
        [localContext MR_saveToPersistentStoreAndWait];
    }
}

@end
