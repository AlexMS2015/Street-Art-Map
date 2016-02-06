//
//  AppDelegate.m
//  Street Art Map
//
//  Created by Alex Smith on 5/07/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseAvailability.h"
@import CoreData;

@interface AppDelegate ()

@property (strong, nonatomic) NSManagedObjectContext *databaseContext;

@end

@implementation AppDelegate

#pragma mark - Properties

-(void)setDatabaseContext:(NSManagedObjectContext *)databaseContext
{
    _databaseContext = databaseContext;
    _databaseContext.undoManager = [[NSUndoManager alloc] init];
    
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
    application.applicationSupportsShakeToEdit = YES;
        
    return YES;
}

@end
