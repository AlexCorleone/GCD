//
//  AppDelegate.h
//  GCD
//
//  Created by AlexCorleone on 2017/6/7.
//  Copyright © 2017年 AlexCorleone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

