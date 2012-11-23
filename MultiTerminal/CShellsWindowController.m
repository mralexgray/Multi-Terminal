//
//  CShellsWindowController.m
//  MultiTerminal
//
//  Created by Jonathan Wight on 1/23/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import "CShellsWindowController.h"

#import "CShellSession.h"
#import "CBlockValueTransformer.h"

@interface CShellsWindowController () <NSCollectionViewDelegate>
@property (readwrite, nonatomic, strong) NSArray *shellSessions;
@property (readwrite, nonatomic, strong) IBOutlet NSArrayController *sessionsController;
@property (readwrite, nonatomic, strong) NSString *script;
@end

#pragma mark -

@implementation CShellsWindowController

+ (void)initialize
    {
    [NSValueTransformer setValueTransformerForName:@"xyzzy" block:^id(id value)
        {
        if ([value intValue] == NO)
            {
            return([NSImage imageNamed:@"CellBackgroundDefault.png"]);
            }
        else
            {
            return([NSImage imageNamed:@"CellBackground.png"]);
            }
        }];
    }

#pragma mark -

- (id)initWithWindow:(NSWindow *)window
    {
    if ((self = [super initWithWindow:window]) != NULL)
        {
        }
    return(self);
    }

#pragma mark -

- (void)windowDidLoad
    {
    [super windowDidLoad];

    self.shellSessions = @[];

    [self loadSessions];
    }

#pragma mark -

- (void)loadSessions
    {
    NSData *theShellSessionsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"shellSessions"];
    if (theShellSessionsData == NULL)
        {
        return;
        }
    NSArray *theShellSessions = [NSKeyedUnarchiver unarchiveObjectWithData:theShellSessionsData];
    if (theShellSessions == NULL)
        {
        return;
        }
    self.shellSessions = theShellSessions;
    }

- (void)saveSessions
    {
    NSData *theSessions = [NSKeyedArchiver archivedDataWithRootObject:self.shellSessions];

    [[NSUserDefaults standardUserDefaults] setObject:theSessions forKey:@"shellSessions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }

#pragma mark -

- (IBAction)runScript:(id)sender
    {
    NSLog(@"RUN SCRIPT: %@", self.script);

    for (CShellSession *theSession in self.sessionsController.selectedObjects)
        {
        [theSession runScript:self.script handler:NULL];
        }
    }

- (IBAction)add:(id)sender
    {
    NSOpenPanel *theOpenPanel = [NSOpenPanel openPanel];
    theOpenPanel.canChooseDirectories = YES;
    theOpenPanel.canChooseFiles = NO;
    theOpenPanel.allowsMultipleSelection = YES;
    [theOpenPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
            {
            for (NSURL *theURL in theOpenPanel.URLs)
                {
                CShellSession *theSession = [[CShellSession alloc] initWithURL:theURL];
                self.shellSessions = [self.shellSessions arrayByAddingObject:theSession];
                }
            [self saveSessions];
            }
        }];
    }

- (IBAction)filterOut:(id)sender
	{
	CShellSession *theFilteredSession = self.sessionsController.selectedObjects[0];

	NSMutableArray *theNewSessions = [self.shellSessions mutableCopy];

	for (CShellSession *theSession in self.shellSessions)
		{
		if ([theFilteredSession.output isEqualToString:theSession.output])
			{
			[theNewSessions removeObject:theSession];
			}
		}
	self.shellSessions = [theNewSessions copy];

    [self saveSessions];
	}

- (IBAction)openTerminal:(id)sender
	{
	for (CShellSession *theSession in self.sessionsController.selectedObjects)
		{

		[[NSWorkspace sharedWorkspace] openURLs:@[ theSession.URL ] withAppBundleIdentifier:@"com.apple.Terminal" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:NULL launchIdentifiers:NULL];


		}
	}

- (IBAction)deleteBackward:(id)sender
    {
    [self.sessionsController removeObjects:self.sessionsController.selectedObjects];

    [self saveSessions];
    }



#pragma mark -

//- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id <NSDraggingInfo> )draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation
//    {
//    return(NSDragOperationCopy);
//    }
//    
//- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id <NSDraggingInfo> )draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation
//    {
//    return(YES);
//    }
//
//- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event
//    {
//    return(YES);
//    }
//    
//- (NSImage *)collectionView:(NSCollectionView *)collectionView draggingImageForItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event offset:(NSPointPointer)dragImageOffset
//    {
//    return(NULL);
//    }
//    
//- (NSArray *)collectionView:(NSCollectionView *)collectionView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropURL forDraggedItemsAtIndexes:(NSIndexSet *)indexes
//    {
//    return(NULL);
//    }
//
//- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard
//    {
//    return(YES);
//    }

@end
