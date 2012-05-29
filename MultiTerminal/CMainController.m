//
//  CMainController.m
//  MultiTerminal
//
//  Created by Jonathan Wight on 1/23/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import "CMainController.h"

#import "CShellsWindowController.h"

@interface CMainController ()
@property (readwrite, nonatomic, strong) CShellsWindowController *shellsWindowController;
@end

#pragma mark -

@implementation CMainController

@synthesize shellsWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)notification;
    {
    
    self.shellsWindowController = [[CShellsWindowController alloc] initWithWindowNibName:@"CShellsWindowController"];
    [self.shellsWindowController.window makeKeyAndOrderFront:self];
    }

@end
