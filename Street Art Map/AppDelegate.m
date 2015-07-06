//
//  AppDelegate.m
//  Street Art Map
//
//  Created by Alex Smith on 5/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseAvailability.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSManagedObjectContext *databaseContext;

@end

@implementation AppDelegate

#pragma mark - Properties

-(void)setDatabaseContext:(NSManagedObjectContext *)databaseContext
{
    _databaseContext = databaseContext;
    
    NSDictionary *userInfo = @{DATABASE_CONTEXT : self.databaseContext};
    [[NSNotificationCenter defaultCenter] postNotificationName:DATABASE_AVAILABLE_NOTIFICATION
                                                        object:self
                                                      userInfo:userInfo];
}

#pragma mark - Application Life Cycle

-(void)startUsingDocument:(UIManagedDocument *)document
{
    if (document.documentState == UIDocumentStateNormal) {
        self.databaseContext = document.managedObjectContext;
    }
}

-(void)getManagedDocument
{
    // get a managed object context for the core data database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    
    NSString *documentName = @"MyDatabase";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url]; // this just creates the UIManagedDocument instance but not the underlying file (nor does it open it)
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    
    if (fileExists) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                [self startUsingDocument:document];
            } else {
                NSLog(@"Document failed to open");
            }
        }];
    } else {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  [self startUsingDocument:document];
              } else {
                  NSLog(@"Document failed to open");
              }
          }];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self getManagedDocument];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
