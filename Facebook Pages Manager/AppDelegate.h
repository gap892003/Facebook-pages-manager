//
//  AppDelegate.h
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/19/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

